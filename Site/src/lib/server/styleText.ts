/**
 * Makes CSS safe to place inside a `<style>` element, so it can't close the element and start HTML such as `</style><script>`.
 * `<` is never valid in CSS outside a string, and inside a string `\3c ` is the escape for the same character, so the CSS means the same afterwards.
 */
export const styleText = (css: string): string =>
	css.replaceAll("<", String.raw`\3c `)
