import fs from "fs"
import "dotenv/config"

const strings = {
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
	type: string,
	imageAssetId: string | number,
	graphicAssetId: string | number
) {
	const stringType = strings[type as keyof typeof strings]
	const asset = fs
		.readFileSync(
			`xml/graphicAsset${
				type === "Face" || type === "Decal" ? "Image" : "Other"
			}.xml`,
			"utf-8"
		)
		.replaceAll("_CLASS", stringType.class)
		.replaceAll("_CONTENT_NAME", stringType.contentName)
		.replaceAll("_STRING_NAME", stringType.stringName)
		.replaceAll(
			"_ASSET_URL",
			`${process.env.RCC_ORIGIN}/asset?id=${imageAssetId.toString()}`
		)

	fs.writeFileSync(`data/assets/${graphicAssetId}`, asset)
}
