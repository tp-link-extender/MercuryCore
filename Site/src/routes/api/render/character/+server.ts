export const GET = async () =>
	new Response(
		(await Bun.file("xml/bodyColours.xml").text())
			.replace("_HEAD", "1")
			.replace("_LEFT_ARM", "1")
			.replace("_LEFT_LEG", "1")
			.replace("_RIGHT_ARM", "1")
			.replace("_RIGHT_LEG", "1")
			.replace("_TORSO", "1")
	)
