export interface RenderUpdate {
	body?: Uint8Array<ArrayBuffer>
	head?: Uint8Array<ArrayBuffer>
	status: string
}

const newline = 10

/**
 * Splits a render status update from the RCCService proxy into its status line and images.
 * The proxy sends the status, a newline, the body and head lengths as 32-bit big-endian integers, then the body and head images.
 * @param content The raw request body.
 * @returns The status, and the body and head images when they were sent.
 */
export function parseRenderUpdate(content: Uint8Array): RenderUpdate {
	const statusEnd = content.indexOf(newline)
	if (statusEnd === -1) return { status: new TextDecoder().decode(content) }

	const status = new TextDecoder().decode(content.slice(0, statusEnd))
	// Sliced rather than subarrayed, so the lengths start at the front of their own buffer
	const rest = content.slice(statusEnd + 1)
	if (rest.length < 8) return { status }

	const lengths = new DataView(rest.buffer, rest.byteOffset, 8)
	const bodyLength = lengths.getUint32(0)
	const headLength = lengths.getUint32(4)

	const bodyStart = 8
	const headStart = bodyStart + bodyLength

	return {
		body: bodyLength > 0 ? rest.slice(bodyStart, headStart) : undefined,
		head:
			headLength > 0
				? rest.slice(headStart, headStart + headLength)
				: undefined,
		status,
	}
}
