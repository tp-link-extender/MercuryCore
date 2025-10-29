/**
 * Handles form data in a simpler way.
 * @param request A request object.
 * @returns An object containing the form data.
 * @example
 * const data = await formData(request)
 * const { text } = data
 */
export default async function (request: Request) {
	const entries = Object.fromEntries((await request.formData()).entries())
	// Object.fromEntries already filters out non-own properties, so we can return directly
	return entries as { [_: string]: string }
}
