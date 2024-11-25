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
	const data: { [k: string]: string } = {}
	for (const i in entries)
		if (Object.hasOwn(entries, i)) data[i] = entries[i] as string

	return data
}
