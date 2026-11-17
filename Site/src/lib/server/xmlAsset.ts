import config from "$lib/server/config"
import { fillXmlTemplate } from "$lib/server/xmlTemplate"

const strings = Object.freeze({
	Decal: ["Decal", "Texture", "Decal"],
	Face: ["Decal", "Texture", "face"],
	Pants: ["Pants", "PantsTemplate", "Pants"],
	Shirt: ["Shirt", "ShirtTemplate", "Shirt"],
	"T-Shirt": ["ShirtGraphic", "Graphic", "Shirt Graphic"],
})

type GraphicType = keyof typeof strings

/**
 * Creates a new XML graphic asset and saves it in ../data/assets
 * @param type The type of asset to create
 * @param imageAssetId The ID of the image asset to link to
 * @param graphicAssetId The ID of the graphic asset to create
 * @example
 * graphicAsset("T-Shirt", imageAssetId, id)
 */
export async function graphicAsset(
	type: GraphicType,
	imageAssetId: number,
	graphicAssetId: number
) {
	const stringType = strings[type]
	const assetType = ["Decal", "Face"].includes(type) ? "Image" : "Other"
	const assetUrl = `http://${config.Domain}/asset?id=${imageAssetId}`

	const assetFile = Bun.file(`xml/graphicAsset${assetType}.xml`)
	const asset = fillXmlTemplate(await assetFile.text(), {
		ASSET_URL: assetUrl,
		CLASS: stringType[0],
		// The image template hardcodes its content name, so only the other one takes a value
		...(assetType === "Other" ? { CONTENT_NAME: stringType[1] } : {}),
		STRING_NAME: stringType[2],
	})

	await Bun.write(`../data/assets/${graphicAssetId}`, asset)
}
