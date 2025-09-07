export async function GET() {
	const script = await Bun.file("../Corescripts/studio.lua").text()

	return new Response(script)
}
