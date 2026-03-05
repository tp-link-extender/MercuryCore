const xmlStart = "<roblox"

export const isXML = (buf: ArrayBuffer) =>
	buf.byteLength >= 7 &&
	new Uint8Array(buf.slice(0, 7)).every(
		(b, i) => b === xmlStart.charCodeAt(i) // we ont need unicote here but who care
	)
