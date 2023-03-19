// Handle form data

export default async function (request: Request) {
	const entries = Object.fromEntries((await request.formData()).entries())
	const data: { [k: string]: string } = {}
	for (let entry in entries) data[entry] = (entries[entry] as string).trim()
	console.log(data)
	return data
}
