export async function GET() {
	const script = await Bun.file("../data/server/loadscripts/studio.lua").text()

	return new Response(script)
}
