const xmlStart = "<roblox"

// worst heuristic ever
/**
 * Checks if the given binary buffer is likely to be an XML document by checking if it starts with "<roblox".
 * @param buf The ArrayBuffer to check.
 * @returns true if the buffer is likely an XML document, false otherwise.
 */
export const isXML = (buf: ArrayBuffer) =>
	buf.byteLength >= 7 &&
	new Uint8Array(buf.slice(0, 7)).every(
		(b, i) => b === xmlStart.charCodeAt(i) // we ont need unicote here but who care
	)
