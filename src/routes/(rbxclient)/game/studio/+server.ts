import { SignData } from "$lib/server/sign"

export const GET = async () =>
	new Response(
		await SignData(
			await Bun.file("corescripts/processed/studio.lua").text()
		)
	)
