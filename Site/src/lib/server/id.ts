// Very legacy
export function randomId() {
	const chars = "abcdefghijklmnopqrstuvwxyz0123456789"
	const result = []
	for (let i = 0; i < 20; i++)
		result.push(chars[Math.floor(Math.random() * chars.length)])
	return result.join("")
}

const min = 100_000_000
const max = 1_000_000_000 // exclusive
export const randomAssetId = () => Math.floor(Math.random() * (max - min) + min)
