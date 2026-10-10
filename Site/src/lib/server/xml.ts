const xmlStart = "<roblox "

// worst heuristic ever
/**
 * Checks if the given binary buffer is likely to be an XML document by checking if it starts with "<roblox".
 * @param buf The ArrayBuffer to check.
 * @returns true if the buffer is likely an XML document, false otherwise.
 */
export const isXML = (buf: ArrayBuffer) =>
	// binary places also start with "<roblox" ("<roblox!\x89\xff..."),
	// the 8th byte is where they differ: '!' for binary, ' ' for XML
	buf.byteLength >= 8 &&
	new Uint8Array(buf.slice(0, 8)).every(
		(b, i) => b === xmlStart.charCodeAt(i)
	)
