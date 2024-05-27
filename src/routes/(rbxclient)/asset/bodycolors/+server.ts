import { equery, surrealql } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"

type User = {
	bodyColours: {
		Head: number
		Torso: number
		LeftArm: number
		RightArm: number
		LeftLeg: number
		RightLeg: number
	}
}

export async function GET({ url }) {
	const id = url.searchParams.get("id")
	if (!id || !/^\d+$/.test(id)) error(400, "Missing id parameter")

	const [[getUser]] = await equery<User[][]>(
		surrealql`SELECT bodyColours FROM user WHERE number = ${+id}`
	)
	if (!getUser) error(404, "User not found")

	const colours = getUser.bodyColours
	return new Response(
		`
<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<roblox xmlns:xmime="http://www.w3.org/2005/05/xmlmime" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.roblox.com/roblox.xsd" version="4">
	<External>null</External>
	<External>nil</External>
	<Item class="BodyColors">
		<Properties>
			<string name="Name">Body Colors</string>
			<int name="HeadColor">${colours.Head}</int>
			<int name="LeftArmColor">${colours.LeftArm}</int>
			<int name="LeftLegColor">${colours.LeftLeg}</int>
			<int name="RightArmColor">${colours.RightArm}</int>
			<int name="RightLegColor">${colours.RightLeg}</int>
			<int name="TorsoColor">${colours.Torso}</int>
			<bool name="archivable">true</bool>
		</Properties>
	</Item>
</roblox>`,
		{
			headers: {
				Pragma: "no-cache",
				"Cache-Control": "no-cache",
				"Content-Type": "text/plain",
			},
		}
	)
}
