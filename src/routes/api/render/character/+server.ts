export const GET = () =>
	new Response(`<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<roblox xmlns:xmime="http://www.w3.org/2005/05/xmlmime"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:noNamespaceSchemaLocation="http://www.roblox.com/roblox.xsd" version="4">
	<External>null</External>
	<External>nil</External>
	<Item class="BodyColors">
		<Properties>
			<string name="Name">Body Colors</string>
			<int name="HeadColor">1</int>
			<int name="LeftArmColor">1</int>
			<int name="LeftLegColor">1</int>
			<int name="RightArmColor">1</int>
			<int name="RightLegColor">1</int>
			<int name="TorsoColor">1</int>
			<bool name="archivable">true</bool>
		</Properties>
	</Item>
</roblox>`)
