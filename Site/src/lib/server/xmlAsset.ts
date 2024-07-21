import config from "./config.ts"

const strings = Object.freeze({
	"T-Shirt": {
		class: "ShirtGraphic",
		contentName: "Graphic",
		stringName: "Shirt Graphic",
	},
	Shirt: {
		class: "Shirt",
		contentName: "ShirtTemplate",
		stringName: "Shirt",
	},
	Pants: {
		class: "Pants",
		contentName: "PantsTemplate",
		stringName: "Pants",
	},
	Decal: { class: "Decal", contentName: "Texture", stringName: "Decal" },
	Face: { class: "Decal", contentName: "Texture", stringName: "face" },
})

/**
 * Creates a new XML graphic asset and saves it in data/assets
 * @param type The type of asset to create
 * @param imageAssetId The ID of the image asset to link to
 * @param graphicAssetId The ID of the graphic asset to create
 * @example
 * graphicAsset("T-Shirt", imageAssetId, id)
 */
export async function graphicAsset(
	type: string,
	imageAssetId: string | number,
	graphicAssetId: string | number
) {
	const stringType = strings[type as keyof typeof strings]
	const assetType = type === "Face" || type === "Decal" ? "Image" : "Other"
	const file = Bun.file(`xml/graphicAsset${assetType}.xml`)

	const asset = (await file.text())
		.replaceAll("_CLASS", stringType.class)
		.replaceAll("_CONTENT_NAME", stringType.contentName)
		.replaceAll("_STRING_NAME", stringType.stringName)
		.replaceAll(
			"_ASSET_URL",
			`${config.Domain}/asset?id=${imageAssetId.toString()}`
		)
	await Bun.write(`data/assets/${graphicAssetId}`, asset)
}
