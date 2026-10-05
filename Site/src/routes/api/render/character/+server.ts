export const GET = async () =>
	new Response(
		(await Bun.file("xml/bodyColours.xml").text())
			.replace("_HEAD", "1001")
			.replace("_LEFT_ARM", "1001")
			.replace("_LEFT_LEG", "1001")
			.replace("_RIGHT_ARM", "1001")
			.replace("_RIGHT_LEG", "1001")
			.replace("_TORSO", "1001"),
		{
			headers: {
				Pragma: "no-cache",
				"Cache-Control": "no-cache",
				"Content-Type": "text/xml",
			},
		}
	)
