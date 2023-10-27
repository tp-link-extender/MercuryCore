import fs from "fs"

const strings = {
	"T-Shirt": {
		class: "ShirtGraphic",
		contentName: "Graphic",
		stringName: "Shirt Graphic",
	},
	Decal: { class: "Decal", contentName: "Texture", stringName: "Decal" },
	Face: { class: "Decal", contentName: "Texture", stringName: "face" },
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
}

/**
 * Creates a new XML graphic asset and saves it in data/assets
 * @param type The type of asset to create
 * @param imageAssetId The ID of the image asset to link to
 * @param graphicAssetId The ID of the graphic asset to create
 * @example
 * graphicAsset("T-Shirt", imageAssetId, id)
 */
export function graphicAsset(
	type: keyof typeof strings,
	imageAssetId: string | number,
	graphicAssetId: string | number,
) {
	const asset = fs
		.readFileSync(
			`xml/graphicAsset${
				type == "Face" || type == "Decal" ? "Image" : "Other"
			}.xml`,
			"utf-8",
		)
		.replaceAll("_CLASS", strings[type].class)
		.replaceAll("_CONTENT_NAME", strings[type].contentName)
		.replaceAll("_STRING_NAME", strings[type].stringName)
		.replaceAll("_ASSET_ID", imageAssetId.toString())

	fs.writeFileSync(`data/assets/${graphicAssetId}`, asset)
}
