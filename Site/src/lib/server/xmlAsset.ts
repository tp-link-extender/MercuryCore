import config from "$lib/server/config"

const strings = Object.freeze({
	"T-Shirt": ["ShirtGraphic", "Graphic", "Shirt Graphic"],
	Shirt: ["Shirt", "ShirtTemplate", "Shirt"],
	Pants: ["Pants", "PantsTemplate", "Pants"],
	Decal: ["Decal", "Texture", "Decal"],
	Face: ["Decal", "Texture", "face"],
})

/**
 * Creates a new XML graphic asset and saves it in ../data/assets
 * @param type The type of asset to create
 * @param imageAssetId The ID of the image asset to link to
 * @param graphicAssetId The ID of the graphic asset to create
 * @example
 * graphicAsset("T-Shirt", imageAssetId, id)
 */
export async function graphicAsset(
	type: string,
	imageAssetId: number,
	graphicAssetId: number
) {
	const stringType = strings[type as keyof typeof strings]
	const assetType = type === "Face" || type === "Decal" ? "Image" : "Other"
	const assetUrl = `http://${config.Domain}/asset?id=${imageAssetId}`

	const assetFile = Bun.file(`xml/graphicAsset${assetType}.xml`)
	// Combine multiple replaceAll into a single pass for better performance
	const replacements: Record<string, string> = {
		_CLASS: stringType[0],
		_CONTENT_NAME: stringType[1], // Unused at the moment
		_STRING_NAME: stringType[2],
		_ASSET_URL: assetUrl,
	}
	const asset = (await assetFile.text()).replace(
		/_CLASS|_CONTENT_NAME|_STRING_NAME|_ASSET_URL/g,
		match => replacements[match]
	)

	await Bun.write(`../data/assets/${graphicAssetId}`, asset)
}
