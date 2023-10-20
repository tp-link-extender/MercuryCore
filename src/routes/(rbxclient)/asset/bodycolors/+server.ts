import { squery, surql } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"

export async function GET({ url, setHeaders }) {
	const id = url.searchParams.get("id")
	if (!id || !/^\d+$/.test(id)) throw error(400, "Missing id parameter")

	const getUser = await squery<{
		bodyColours: {
			Head: number
			Torso: number
			LeftArm: number
			RightArm: number
			LeftLeg: number
			RightLeg: number
		}
	}>(
		surql`
			SELECT bodyColours FROM user
			WHERE number = $id`,
		{ id: parseInt(id) },
	)

	if (!getUser) throw error(404, "User not found")

	const colours = getUser.bodyColours

	setHeaders({
		Pragma: "no-cache",
		"Cache-Control": "no-cache",
	})

	return new Response(`
<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<roblox xmlns:xmime="http://www.w3.org/2005/05/xmlmime" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.roblox.com/roblox.xsd" version="4">
	<External>null</External>
	<External>nil</External>
	<Item class="BodyColors">
		<Properties>
			<int name="HeadColor">${colours.Head}</int>
			<int name="LeftArmColor">${colours.LeftArm}</int>
			<int name="LeftLegColor">${colours.LeftLeg}</int>
			<string name="Name">Body Colors</string>
			<int name="RightArmColor">${colours.RightArm}</int>
			<int name="RightLegColor">${colours.RightLeg}</int>
			<int name="TorsoColor">${colours.Torso}</int>
			<bool name="archivable">true</bool>
		</Properties>
	</Item>
</roblox>`)
}
