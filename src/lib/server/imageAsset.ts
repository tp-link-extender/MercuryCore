import fs from "fs"
import sharp from "sharp"

/**
 * Creates an image asset based off a file object
 * @param file A File object for the image to save
 * @param sharpOptions Extra options to pass to sharp
 * @returns A function that saves the image to data/assets
 * @example
 * const save = await imageAsset(image)
 * const id = // Load from database
 * save(id)
 */
export async function imageAsset(
	file: File,
	sharpOptions?: sharp.ResizeOptions,
) {
	const fileBuffer = await sharp(await file.arrayBuffer())
		.resize(420, 420, {
			fit: "inside",
			...sharpOptions,
		})
		.png()
		.toBuffer()
		.catch(() => {
			throw new Error("Image asset failed to upload")
		})

	return (id: string | number) =>
		fs.writeFileSync(`data/assets/${id}`, fileBuffer)
}

/**
 * Creates an image thumbnail based off a file object
 * @param file A File object for the image to save
 * @param sharpOptions Extra options to pass to sharp
 * @returns A function that saves the image to data/assets
 * @example
 * const save = await thumbnail(image)
 * const id = // Load from database
 * save(id)
 */
export async function thumbnail(
	file: File,
	sharpOptions?: sharp.ResizeOptions,
) {
	const fileBuffer = await sharp(await file.arrayBuffer())
		.resize(420, 420, {
			fit: "fill",
			...sharpOptions,
		})
		.webp()
		.toBuffer()
		.catch(() => {
			throw new Error("Thumbnail failed to upload")
		})

	return (id: string | number) =>
		fs.writeFileSync(`data/thumbnails/${id}`, fileBuffer)
}

/**
 * Creates an T-Shirt image asset based off a file object
 * @param file A File object for the image to save
 * @returns A function that saves the image to data/assets
 * @example
 * const save = await tShirt(image)
 * const id = // Load from database
 * save(id)
 */
export async function tShirt(file: File) {
	const fileBuffer = await sharp(await file.arrayBuffer())
		.resize(420, 420, {
			fit: "contain",
			position: "top",
			background: { r: 0, g: 0, b: 0, alpha: 0 },
		})
		.png()
		.toBuffer()
		.catch(() => {
			throw new Error("Image asset failed to upload")
		})

	return (id: string | number) =>
		fs.writeFileSync(`data/assets/${id}`, fileBuffer)
}

/**
 * Creates a T-Shirt thumbnail based off a file object
 * @param file A File object for the image to save
 * @returns A function that saves the image to data/assets
 * @example
 * const save = await tShirtThumbnail(image)
 * const id = // Load from database
 * save(id)
 */
export async function tShirtThumbnail(file: File) {
	const fileBuffer = await sharp("static/tShirtTemplate.webp")
		.composite([
			{
				input: await sharp(await file.arrayBuffer())
					.resize(420, 420, {
						fit: "contain",
						position: "top",
						background: { r: 0, g: 0, b: 0, alpha: 0 },
					})
					.toBuffer(),
			},
		])
		.webp()
		.toBuffer()
		.catch(() => {
			throw new Error("Thumbnail failed to upload")
		})

	return (id: string | number) =>
		fs.writeFileSync(`data/thumbnails/${id}`, fileBuffer)
}
