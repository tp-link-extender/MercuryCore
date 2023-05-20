import fs from "fs"
import sharp from "sharp"

export async function imageAsset(
	file: File,
	sharpOptions?: sharp.ResizeOptions
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

export async function thumbnail(
	file: File,
	sharpOptions?: sharp.ResizeOptions
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

export async function tShirt(file: File) {
	const fileBuffer = await sharp(await file.arrayBuffer())
		.resize(128, 128, {
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

export async function tShirtThumbnail(file: File) {
	const fileBuffer = await sharp("static/tShirtTemplate.webp")
		.composite([
			{
				input: await sharp(await file.arrayBuffer())
					.resize(250, 250, {
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
		fs.writeFileSync(`data/thumbnails/${id}.png`, fileBuffer)
}
