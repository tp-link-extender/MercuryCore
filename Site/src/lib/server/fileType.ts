import { isXML } from "./xml.js"

const text = (buf: ArrayBuffer, count: number) =>
	new TextDecoder().decode(buf.slice(0, count))

const startsWith = (buf: ArrayBuffer, magic: string) =>
	buf.byteLength >= magic.length && text(buf, magic.length) === magic

export const isMesh = (buf: ArrayBuffer) => startsWith(buf, "version ")
export const isRobloxModel = (buf: ArrayBuffer) =>
	isXML(buf) || startsWith(buf, "<roblox!")
export const isAudio = (buf: ArrayBuffer) => startsWith(buf, "OggS")

export const isImage = async (file: File) => {
	try {
		await new Bun.Image(file).metadata()
		return true
	} catch {
		return false
	}
}
