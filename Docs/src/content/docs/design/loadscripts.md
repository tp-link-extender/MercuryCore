---
title: Loadscripts
description: The contract between the 2013 loadscript templates and the Site, for type-safe interpolation.
---

Loadscripts are some of the first scripts a 2013 client runs when it joins a place, hosts a server, or visits a place. They are written as Luau in the 2013 repository, compiled to Lua, and served by the Site. This process is detailed more in the [Corescripts setup guide](/guides/coresetup).

Before serving, the Site replaces each Lua script's placeholder identifiers/symbols with values for the request, and then signs the result. This page describes how the 2 sides are connected, how the Site checks its values against the templates, and what needs to be updated when the templated variables in a Luau script change.

## Files

| File | Role |
| --- | --- |
| `2013/Loadscripts/*.luau` | Templates, as written by hand. |
| `2013/compile/` | Compiles the templates, currently with darklua, into `2013/out/server/loadscripts/`. Writes the manifest when given `-manifest <path>`. |
| `2013/compile/placeholders.go` | Finds placeholders in a compiled script, following the Site's rules. |
| `MercuryCore/data/server/loadscripts/*.lua` | Compiled Loadscript copies the Site reads. Gitignored and local to each machine, so they're copied by hand. |
| `MercuryCore/Site/src/lib/server/loadscript.ts` | `buildLoadscript`, which fills a template. |
| `MercuryCore/Site/src/lib/server/loadscriptFile.ts` | `buildNamedLoadscript`, which reads a loadscript by name with values typed to match it. |
| `MercuryCore/Site/src/lib/server/loadscripts.manifest.json` | The placeholders in each Loadscript, from the compile step. |
| `MercuryCore/Site/src/lib/server/loadscripts.gen.ts` | Generated value types, 1 for each Loadscript. Shouldn't need to be edited. |
| `MercuryCore/Site/scripts/loadscripts.ts` | Generates `loadscripts.gen.ts` from the manifest. |

## Placeholders

A placeholder is a whole identifier that starts with an underscore, followed by an uppercase letter and then any number of uppercase letters, digits, or underscores. It matches `_[A-Z][A-Z0-9_]*`. For example, `_PLACE_ID` and `_PORT2` count as placeholders, while `_place`, `FOO_BAR` and `_` do not.

Lua's own globals `_G` and `_VERSION` are never placeholders, so remain unchanged.

Where a placeholder appears decides how its value is written:

| Location | Example in template | Result with `PLACE_ID: 42` |
| --- | --- | --- |
| Code | `local id = _PLACE_ID` | `local id = 42` |
| Short string | `local name = "_USERNAME"` | `local name = "Player1"` |
| Line comment | `-- _PLACE_ID` | unchanged |
| Long comment | `--[[ _PLACE_ID ]]` | unchanged |
| Long string | `[[_PLACE_ID]]` | cannot be filled (see [Known gaps](#known-gaps)) |

Values are written according to their type:

- A **string** in code becomes a quoted Lua literal, with bytes escaped as needed. Inside a string, it's escaped as string content and cannot end its enclosing string.
- A **number** in code stays a number. A negative number is wrapped in parentheses, so a template like `-_X` can't turn into a comment.
- A **raw** value, made with `luaName` or `luaId`, is written as Lua source. These are only for names the Site writes itself. Never pass user input as a raw value.

Substituted values are never scanned again, so a value can't introduce a new placeholder.

## Filling a template

`buildLoadscript(template, values)` does the substitution in one pass. It errors, rather than producing a script, when:

- a placeholder in code or in a string has no value (`Loadscript placeholder _NAME has no value`),
- a value has no placeholder in the template (`Loadscript value _NAME has no placeholder`),
- a placeholder with a value is inside a long string (`... inside a long string, where it can't be escaped`),
- a string or long bracket is not closed.

Throwing on unused values is deliberate. A value with no placeholder means the template and its caller have drifted apart, which is the bug that this contract exists to catch.

## Typed values

`buildNamedLoadscript(name, values)` reads `data/server/loadscripts/<name>.lua` and fills it in. Its `values` argument is typed from `loadscripts.gen.ts`:

- Every placeholder in the manifest is a required key, with type `LoadscriptValue` (`string | number | RawLua`).
- A loadscript with no placeholders, such as `studio`, takes `{}`.
- `LoadscriptName` is the union of the loadscript names, so an unknown name fails the typecheck.

A missing key, an extra key, or an unknown name is therefore a type error in the Site before it's a runtime error for a player. The types check the names, and that each value is a string, a number or raw Lua. The runtime checks the rest, such as whether a number is finite.

## The manifest

The compile step writes the manifest from its own output rather than from the templates. This makes it a record of what the Site will actually receive. Run the following from the 2013 `compile/` directory:

```bash
go run . -manifest /path/to/MercuryCore/Site/src/lib/server/loadscripts.manifest.json
```

Replacing `/path/to/MercuryCore` with the path of the Mercury Core source code on your machine, allowing ~ for the home directory.

Without `-manifest`, the compile behaves as before. The manifest is a JSON object, where each key is a loadscript's file name omitting its extension, and each value is the sorted list of its placeholder names:

```json
{
	"join": ["CHAR_APPEARANCE", "CREATOR_ID", "MEMBERSHIP_TYPE", "PING_URL", "PLACE_ID", "SERVER_ADDRESS", "SERVER_PORT", "USERNAME", "USER_ID"],
	"studio": [],
	"visit": ["PLACE_ID"]
}
```

`placeholders.go` follows the same rules as `buildLoadscript`: comments are skipped, short and long strings are read, and Lua's globals are excluded. Its tests cover each rule. `parseManifest` in `loadscripts.ts` rejects anything that isn't an object mapping names to lists of strings.

## Generating the types

After the manifest changes, regenerate the types from the Site:

```bash
cd MercuryCore/Site
bun scripts/loadscripts.ts
```

Each name must match `^[a-z][A-Za-z0-9]*$`, so it can become a type name. Names with underscores or dashes are refused. The output is sorted, so it doesn't depend on the manifest's order.

## Updating after a 2013 change

1. Compile from the 2013 `compile/` directory, with the `-manifest` flag pointing at the Site's manifest. Make sure to run this from the 2013 directory, since the compiler may rely on tools only available in that directory.
2. Copy the compiled scripts from `2013/out/server/loadscripts/*.lua` into `MercuryCore/data/server/loadscripts/`. This is a manual step, as `data/` is ignored from source control.
3. Run `bun scripts/loadscripts.ts` in `Site/`.
4. Run `bun check`, and fix any call site it rejects. A renamed placeholder shows up here, for example `USER_NAME` in place of `USERNAME`.
5. Commit the manifest and the generated file together.

If step 2 is skipped, the Site keeps serving the old compiled scripts. A call site with a renamed key then fails at runtime with `has no placeholder`.

## What is checked, and where

| Check | Where it runs | What it catches |
| --- | --- | --- |
| Generated types match the manifest | `bun test` in `Site/` (`scripts/loadscripts.test.ts`). CI runs this. | Editing the manifest without regenerating. |
| Call sites match the types | `bun check`. CI runs this. | Wrong, missing or unknown keys and names. |
| Substitution rules | `bun test` in `Site/` (`loadscript.test.ts`). CI runs this, and runs the escaped output through `luau` when it's installed. | Escaping and placement bugs. |
| Scanner rules | `go test` in `2013/compile/` (`placeholders_test.go`). | Scanner regressions. |
| Manifest matches the 2013 output | Not checked. Only by rerunning the compile step. | Templates changing without the manifest being updated. |
| `data/` matches the 2013 output | Not checked. | A stale compiled copy. |
| Scanner matches `buildLoadscript` on real templates | Not checked. The two scanners share rules, but no test runs them on the same input. | A scanner that agrees with itself and disagrees with the Site. |

## Known gaps

- **Placeholders in long strings** – the scanner counts them, so the manifest and types require them, though `buildLoadscript` currently doesn't fill them. No current template has one, so this doesn't break anything yet. Template scripts must not put placeholders inside long brackets.
- **Render scripts and corescripts** – `requestRender` still builds its script with `buildLoadscript` directly, without typed names. Corescripts and render scripts aren't in the manifest.
- **Freshness** – nothing in CI notices a 2013 template change that hasn't been compiled into the manifest. The typed call sites catch the consequences once they're regenerated, though nothing forces the regeneration.
