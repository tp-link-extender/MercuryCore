import { timingSafeEqual } from "node:crypto"

/** Compares two strings in constant time, so the time taken doesn't reveal how much of a secret was guessed right. */
export default function constantTimeEqual(a: string, b: string): boolean {
	const ah = Buffer.from(a)
	const bh = Buffer.from(b)
	if (ah.byteLength !== bh.byteLength) return false
	return timingSafeEqual(ah, bh)
}
