# Docs

SurrealDB docs at https://surrealdb.com/docs/llms.txt  
SvelteKit docs at https://svelte.dev/docs/kit/llms.txt  
Svelte docs at https://svelte.dev/docs/svelte/llms.txt

# Code style guidelines

- Replace em-dashes (—) with en-dashes (–) in text or comments
	- Use em-dashes only as an explicit empty placeholder value
- Replace en-dashes (–) with hyphens (-) in numerical or temporal ranges

## JS

- Use tabs for indentation
- Prefer double quotes over single quotes for strings
- Prefer string interpolation over concatenation
- Omit semicolons for separating statements
	- If required, for example where a statement starts with a parenthesis, see if it can be split up with a constant declaration
	- If a IIFE is needed, use `void` instead of a semicolon
- Blocks or conditionals with 1 statement should omit braces
	- This includes nested blocks, like `if (x) for (const y of z) ...`
- Arrow functions with only a single return expression should omit braces and the return keyword
- Function declarations should use arrow functions if they have only a single return expression, and standard function declarations otherwise
	- This also applies for top-level functions
	- Use `const` to declare arrow function variables
- Use guard statements to reduce nesting everywhere possible
	- Do this in functions with `return`, and in loops with `continue`
- Prefer `for (const x of y) ...` over `y.forEach(x => ...)`
- Prefer `const` over `let`
	- Avoid `var`
- Use `===` and `!==` over `==` and `!=` except when comparing with null
- Use Object.freeze() to make objects immutable where possible
- Omit `void` before function calls, unless this function call is a IIFE
- Declare only 1 variable per declaration statement, avoid `const x = 1, y = 2, z = 3`
- When making large functions that return objects with many functions, consider if this would be more natural as a class with methods instead

None of this should conflict with the formatting or linting rules of Biome.

## TS

- Use return types on functions
- Avoid `any` types
- Prefer union types over enums
- Prefer `interface` over `type` for object types
- Always use object types with indexers over Record types, for example prefer `{ [_: string]: string }` over `Record<string, string>`

## Svelte

- Use Svelte 5 syntax and runes
- Prefer Svelte's attribute interpolation `"test {x} test"` over standard JS string interpolation `` `test ${x} test` `` where available
- Svelte classes can take an object or array as a value. Always use this syntax `class={["test", x ? "test2" : "test3"]}` instead of string interpolation `class="test {x ? 'test2' : 'test3'}"`
	- There is no need to use single quotes for the class names in the array, as they aren't inside a string interpolation
	- See https://svelte.dev/docs/svelte/class/llms.txt
- Prefer declaration tags `{let x = 5}`, `{const x = 5}` over @const directives `{@const x = 5}`
	- If reactivity is required, use $derived()
	- See https://svelte.dev/docs/svelte/declaration-tags/llms.txt and https://svelte.dev/docs/svelte/@const/llms.txt
- If writing getter and setter functions, see if they can be better served by a reactive class, with $state() fields or get property() & set property() functions
- If something is only intended to run once, prefer onMount() over $effect()
	- Prefer onDestroy() over $effect(() => (() => { ... })())

## CSS

- Avoid `!important` where possible
	- Avoid the equivalent `!` suffix in Tailwind classes
- Avoid margins where possible
	- Replace with padding or gaps where spacing is needed
	- Replace with flex or grid for centreing
	- If needing negative margins for funky tricks, OK
- Use canonical Tailwind classes, like `w-36` instead of `w-[9rem]`
- In the rare case where something is more concise in standard CSS than in Tailwind, write it in standard CSS

## Go

- Use range-over-number `for i := range 5` instead of classic for loops `for i := 0; i < 5; i++` when the index is not mutated inside the loops
	- Same for range-over-slice `for i := range slice` instead of `for i := 0; i < len(slice); i++`
- Use guard clauses where possible to reduce nesting and improve readability
- Put function declarations above their usage in the same file, never below

## Comments

- Do not hard-wrap. Never split a sentence over multiple lines
	- If the new line is after a semicolon or is a new sentence, OK

## Prose

Use these guidelines in documentation or doc-comments. Regular code comments and commit messages need not abide by these.

- Use Standard Scottish English for all spelling and grammar
	- colour > color, flavour > flavor
	- centre > center, metre > meter
	- fulfil > fulfill
	- travelled > traveled, cancelled > canceled
	- organise > organize, standardise > standardize
	- Only use other spellings where required by specification (such as CSS `color`, HTTP `Authorization`)
- Use the serial comma in lists of 3 or more items
- Avoid grammatical contractions
	- Do not > don't, cannot > can't, will not > won't
- Capitalise references to specific services as part of Mercury
	- The Site, the Orbiter, the Studio & Client
	- Leave references uncapitalised when referring to generic terms
- Use bold text rather than code formatting for file paths, unless used in code such as a shell command
	- **/dev/null** > `/dev/null`
- Use double quotes for referencing text, use single quotes for introducing a term where necessary
- Use incidental relative clauses over restrictive relative clauses when referring to items that there are only 1 instance of that item
	- Always use relative pronouns in relative clauses
		- "the script that this runs"/"the script which this runs" > "the script this runs"
- Always use correlative adverbs
- Prefer "though", "however", and "yet" over "but"
- Prefer digits over words for all numbers
	- 1, 2, 3... > one, two, three...
	- 1st, 2nd, 3rd... > first, second, third...
	- 'one' can be used as a pronoun or for specifying rather than counting, such as "one script" or "one of the scripts"
- Prefer comparative over negative contrast constructions
	- "this happens rather than that"/"this happens instead of that" > "this happens, not that"
- Prefer passive over active voice
	- "once the script is run" > "once someone runs the script"
- If using a list and having nested logical connectives, use '&' and '/' instead of 'and' and 'or' in nested list items to avoid ambiguity
	- The symbol forms bind closer than their word forms
	- Separate '&' with spaces on either side,  '/' should not have spaces on either side
	- "Builtins & Hardcoded assets, Corescripts/Loadscripts, and render scripts"
	- "Builtins/Hardcoded assets, Corescripts/Loadscripts, or render scripts"
- If using a list and having nested lists, use ';' instead of ',' to separate the top-level list items
	- The nested logical connectives rule should also be used for clarity
	- "Builtins, Hardcoded assets, & other assets; Corescripts, Loadscripts, & Render scripts; and Plugins, Dependencies, & Libraries.

Ignore all of these rules when quoting direct output.
