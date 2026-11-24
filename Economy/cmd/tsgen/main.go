// Command tsgen writes the TypeScript mirror of the item types in ledger/types.go, so the client's type bytes, ID kinds and classes can't drift from the ledger.
//
// It reads the Go source with go/parser instead of importing the ledger, so the ledger package doesn't depend on any tooling. Only the shapes it understands are accepted. Anything else is an error, so a new kind of method fails generation rather than being silently left out of the client.
//
// Run it with `go generate ./ledger`. The tests fail if the committed client/types.gen.ts is out of date.
package main

import (
	"cmp"
	"errors"
	"flag"
	"fmt"
	"go/ast"
	"go/parser"
	"go/token"
	"os"
	"slices"
	"strconv"
	"strings"
)

// markerOrder is the order the client lists behaviour interfaces in, after the ID interface.
var markerOrder = []string{"CanOwnOne", "CanOwnMany", "Mintable", "Owner", "Source"}

// samples are the values each kind's test instance is built from. The numeric one is the largest uint32, so the test covers the full width. The string one is not ASCII, so the test covers the byte length prefix.
var samples = map[string]string{
	"number": "4294967295",
	"string": `"é"`,
}

type constant struct {
	name string
	value int
}

// kind is one concrete item type, with what the client needs to mirror it.
type kind struct {
	// the Go type name, which is also the TypeScript class name
	name string
	// the Type constant it reports, such as TypeCurrency
	typeName string
	// the value of typeName, which is written as the first byte of every serialised item
	typeByte int
	// "number" for uint32 IDs, "string" for string IDs
	idType string
	// the behaviour interfaces it implements, in markerOrder
	markers []string
	// the type Create returns, or empty if there is none
	create string
	// the body of the String template literal, such as currency(${this.ID})
	format string
}

func main() {
	src := flag.String("src", "types.go", "the Go file to read")
	out := flag.String("out", "types.gen.ts", "the TypeScript file to write")
	flag.Parse()

	b, err := Generate(*src)
	if err != nil {
		fmt.Fprintln(os.Stderr, "tsgen:", err)
		os.Exit(1)
	}

	if err := os.WriteFile(*out, b, 0o644); err != nil {
		fmt.Fprintln(os.Stderr, "tsgen:", err)
		os.Exit(1)
	}
}

// Generate returns the TypeScript for the item types in the Go file at path.
func Generate(path string) ([]byte, error) {
	file, err := parser.ParseFile(token.NewFileSet(), path, nil, parser.SkipObjectResolution)
	if err != nil {
		return nil, err
	}

	consts, err := typeConstants(file)
	if err != nil {
		return nil, err
	}

	kinds, err := itemKinds(file, consts)
	if err != nil {
		return nil, err
	}

	return render(consts, kinds), nil
}

// typeConstants reads the iota block that declares the Type values. Each name's byte value is its position in the block, which is what iota means.
func typeConstants(file *ast.File) ([]constant, error) {
	for _, decl := range file.Decls {
		gen, ok := decl.(*ast.GenDecl)
		if !ok || gen.Tok != token.CONST || len(gen.Specs) == 0 {
			continue
		}

		first, ok := gen.Specs[0].(*ast.ValueSpec)
		if !ok || first.Names[0].Name != "TypeNil" {
			continue
		}

		return iotaBlock(gen)
	}

	return nil, errors.New("no const block starts with TypeNil")
}

func iotaBlock(gen *ast.GenDecl) ([]constant, error) {
	var consts []constant
	for i, spec := range gen.Specs {
		vs, ok := spec.(*ast.ValueSpec)
		if !ok || len(vs.Names) != 1 {
			return nil, errors.New("the Type const block must declare one name per line")
		}

		name := vs.Names[0].Name
		if !strings.HasPrefix(name, "Type") {
			return nil, fmt.Errorf("%s is in the Type const block but is not a Type", name)
		}

		// only the first line states iota, and the lines after it repeat it implicitly
		if i == 0 && !isIota(vs) || i > 0 && vs.Values != nil {
			return nil, fmt.Errorf("%s must take its value from implicit iota", name)
		}

		consts = append(consts, constant{name: name, value: i})
	}

	return consts, nil
}

func isIota(vs *ast.ValueSpec) bool {
	if len(vs.Values) != 1 {
		return false
	}

	id, ok := vs.Values[0].(*ast.Ident)
	return ok && id.Name == "iota"
}

// itemKinds finds every type with a Type method, which is how the ledger marks a concrete item.
func itemKinds(file *ast.File, consts []constant) ([]kind, error) {
	values := map[string]int{}
	for _, c := range consts {
		values[c.name] = c.value
	}

	methods := map[string]map[string]*ast.FuncDecl{}
	for _, decl := range file.Decls {
		fn, ok := decl.(*ast.FuncDecl)
		if !ok || fn.Recv == nil {
			continue
		}

		recv := receiverType(fn.Recv)
		if methods[recv] == nil {
			methods[recv] = map[string]*ast.FuncDecl{}
		}
		methods[recv][fn.Name.Name] = fn
	}

	var kinds []kind
	for name, ms := range methods {
		if ms["Type"] == nil {
			continue
		}

		k, err := describe(name, ms, values)
		if err != nil {
			return nil, err
		}
		kinds = append(kinds, k)
	}

	slices.SortFunc(kinds, func(a, b kind) int {
		return cmp.Compare(a.typeByte, b.typeByte)
	})
	for i := range len(kinds) - 1 {
		if kinds[i].typeByte == kinds[i+1].typeByte {
			return nil, fmt.Errorf("%s and %s share the Type byte %d", kinds[i].name, kinds[i+1].name, kinds[i].typeByte)
		}
	}

	return kinds, nil
}

func receiverType(recv *ast.FieldList) string {
	t := recv.List[0].Type
	if star, ok := t.(*ast.StarExpr); ok {
		t = star.X
	}

	id, ok := t.(*ast.Ident)
	if !ok {
		return ""
	}
	return id.Name
}

func describe(name string, ms map[string]*ast.FuncDecl, values map[string]int) (kind, error) {
	if ms["ID"] == nil || ms["String"] == nil {
		return kind{}, fmt.Errorf("%s needs both ID and String methods", name)
	}

	typeName, err := returnedIdent(ms["Type"])
	if err != nil {
		return kind{}, fmt.Errorf("%s.Type: %w", name, err)
	}

	typeByte, ok := values[typeName]
	if !ok {
		return kind{}, fmt.Errorf("%s.Type returns %s, which is not a Type constant", name, typeName)
	}

	idType, err := idKind(ms["ID"])
	if err != nil {
		return kind{}, fmt.Errorf("%s.ID: %w", name, err)
	}

	format, err := stringFormat(ms["String"], idType)
	if err != nil {
		return kind{}, fmt.Errorf("%s.String: %w", name, err)
	}

	k := kind{name: name, typeName: typeName, typeByte: typeByte, idType: idType, format: format}
	for _, m := range markerOrder {
		if isMarker(ms[m]) {
			k.markers = append(k.markers, m)
		}
	}

	if ms["Create"] != nil {
		k.create, err = createdType(ms["Create"])
		if err != nil {
			return kind{}, fmt.Errorf("%s.Create: %w", name, err)
		}
	}

	return k, nil
}

// isMarker reports whether fn is one of the parameterless methods that mark a behaviour, such as Mintable().
func isMarker(fn *ast.FuncDecl) bool {
	return fn != nil && fn.Type.Params.NumFields() == 0 && fn.Type.Results == nil
}

// idKind maps the return type of ID to the client's ID kind.
func idKind(fn *ast.FuncDecl) (string, error) {
	ret, err := singleResult(fn)
	if err != nil {
		return "", err
	}

	switch ret {
	case "uint32":
		return "number", nil
	case "string":
		return "string", nil
	}
	return "", fmt.Errorf("returns %s, want uint32 or string", ret)
}

// stringFormat checks that String is a single fmt.Sprintf of the ID, and returns its format as the body of a template literal.
func stringFormat(fn *ast.FuncDecl, idType string) (string, error) {
	expr, err := returnExpr(fn)
	if err != nil {
		return "", err
	}

	call, ok := expr.(*ast.CallExpr)
	if !ok || !isSelector(call.Fun, "fmt", "Sprintf") || len(call.Args) != 2 {
		return "", errors.New("must return fmt.Sprintf(format, id)")
	}

	if _, ok := call.Args[1].(*ast.SelectorExpr); !ok {
		return "", errors.New("must format the ID field of the receiver")
	}

	lit, ok := call.Args[0].(*ast.BasicLit)
	if !ok || lit.Kind != token.STRING {
		return "", errors.New("the format must be a string literal")
	}

	format, err := strconv.Unquote(lit.Value)
	if err != nil {
		return "", err
	}

	verb := "%s"
	if idType == "number" {
		verb = "%d"
	}
	if strings.Count(format, "%") != 1 || strings.Count(format, verb) != 1 {
		return "", fmt.Errorf("the format must have exactly one %s", verb)
	}

	before, after, _ := strings.Cut(format, verb)
	if strings.ContainsAny(before+after, "`\\$") {
		return "", errors.New("the format has characters a template literal can't hold")
	}

	return before + "${this.ID}" + after, nil
}

// createdType checks that Create is a plain conversion, such as LimitedAsset(i), which the client writes as new LimitedAsset(this.ID). It returns the converted type.
func createdType(fn *ast.FuncDecl) (string, error) {
	ret, err := singleResult(fn)
	if err != nil {
		return "", err
	}

	expr, err := returnExpr(fn)
	if err != nil {
		return "", err
	}

	call, ok := expr.(*ast.CallExpr)
	if !ok || len(call.Args) != 1 || !isIdent(call.Fun, ret) {
		return "", fmt.Errorf("must return %s(receiver)", ret)
	}

	return ret, nil
}

// returnedIdent returns the name of the identifier that fn returns, such as TypeCurrency for a Type method.
func returnedIdent(fn *ast.FuncDecl) (string, error) {
	expr, err := returnExpr(fn)
	if err != nil {
		return "", err
	}

	id, ok := expr.(*ast.Ident)
	if !ok {
		return "", errors.New("must return an identifier")
	}
	return id.Name, nil
}

// returnExpr returns the only expression fn returns, for functions whose body is just a return.
func returnExpr(fn *ast.FuncDecl) (ast.Expr, error) {
	if fn.Body == nil || len(fn.Body.List) != 1 {
		return nil, errors.New("the body must be a single return")
	}

	ret, ok := fn.Body.List[0].(*ast.ReturnStmt)
	if !ok || len(ret.Results) != 1 {
		return nil, errors.New("the body must be a single return")
	}
	return ret.Results[0], nil
}

// singleResult returns the type name of fn's only result, which must be a plain identifier.
func singleResult(fn *ast.FuncDecl) (string, error) {
	res := fn.Type.Results
	if res == nil || len(res.List) != 1 {
		return "", errors.New("must return exactly one value")
	}

	id, ok := res.List[0].Type.(*ast.Ident)
	if !ok {
		return "", errors.New("the return type must be a plain identifier")
	}
	return id.Name, nil
}

func isIdent(expr ast.Expr, name string) bool {
	id, ok := expr.(*ast.Ident)
	return ok && id.Name == name
}

func isSelector(expr ast.Expr, pkg, name string) bool {
	sel, ok := expr.(*ast.SelectorExpr)
	return ok && isIdent(sel.X, pkg) && sel.Sel.Name == name
}

// render writes the file. The layout follows the Biome formatting of the hand-written client, so the output needs no formatting pass.
func render(consts []constant, kinds []kind) []byte {
	var b strings.Builder
	b.WriteString("// Code generated by tsgen from ledger/types.go. DO NOT EDIT.\n\n")

	used := map[string]bool{"Item": true}
	for _, k := range kinds {
		used[idInterface(k.idType)] = true
		for _, m := range k.markers {
			used[m] = true
		}
	}
	var imports []string
	for _, name := range []string{"Item", "NumericItem", "StringItem", "CanOwnOne", "CanOwnMany", "Mintable", "Owner", "Source"} {
		if used[name] {
			imports = append(imports, name)
		}
	}
	writeImport(&b, imports)

	b.WriteString("export type Type = number\n\n")
	for _, c := range consts {
		fmt.Fprintf(&b, "export const %s: Type = %d\n", c.name, c.value)
	}
	b.WriteString("\n")

	for _, k := range kinds {
		writeClass(&b, k)
	}

	b.WriteString("export interface ItemKind {\n")
	b.WriteString("\treadonly idType: \"number\" | \"string\"\n")
	b.WriteString("\treadonly name: string\n")
	b.WriteString("\treadonly sample: Item\n")
	b.WriteString("\treadonly type: Type\n")
	b.WriteString("}\n\n")

	b.WriteString("export const itemKinds: readonly ItemKind[] = Object.freeze([\n")
	for _, k := range kinds {
		b.WriteString("\t{\n")
		fmt.Fprintf(&b, "\t\tidType: \"%s\",\n", k.idType)
		fmt.Fprintf(&b, "\t\tname: \"%s\",\n", k.name)
		fmt.Fprintf(&b, "\t\tsample: new %s(%s),\n", k.name, samples[k.idType])
		fmt.Fprintf(&b, "\t\ttype: %s,\n", k.typeName)
		b.WriteString("\t},\n")
	}
	b.WriteString("])\n")

	return []byte(b.String())
}

func idInterface(idType string) string {
	if idType == "number" {
		return "NumericItem"
	}
	return "StringItem"
}

// writeImport writes the type-only import of the client interfaces, breaking the names over lines as Biome does past 80 columns.
func writeImport(b *strings.Builder, names []string) {
	line := fmt.Sprintf("import type { %s } from \"./types\"", strings.Join(names, ", "))
	if len(line) <= 80 {
		b.WriteString(line + "\n\n")
		return
	}

	b.WriteString("import type {\n")
	for _, n := range names {
		fmt.Fprintf(b, "\t%s,\n", n)
	}
	b.WriteString("} from \"./types\"\n\n")
}

func writeClass(b *strings.Builder, k kind) {
	ifaces := []string{idInterface(k.idType)}
	ifaces = append(ifaces, k.markers...)

	header := fmt.Sprintf("export class %s implements %s {", k.name, strings.Join(ifaces, ", "))
	if len(header) > 80 {
		fmt.Fprintf(b, "export class %s\n\timplements %s\n{\n", k.name, strings.Join(ifaces, ", "))
	} else {
		b.WriteString(header + "\n")
	}

	fmt.Fprintf(b, "\tType = %s\n\n", k.typeName)
	for _, m := range k.markers {
		fmt.Fprintf(b, "\t%s() {}\n", m)
	}
	b.WriteString("\n")

	fmt.Fprintf(b, "\tconstructor(public ID: %s) {}\n\n", k.idType)
	fmt.Fprintf(b, "\tString(): string {\n\t\treturn `%s`\n\t}\n", k.format)

	if k.create != "" {
		fmt.Fprintf(b, "\n\tCreate(): %s {\n\t\treturn new %s(this.ID)\n\t}\n", k.create, k.create)
	}
	b.WriteString("}\n\n")
}
