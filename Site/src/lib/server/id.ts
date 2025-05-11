// Very legacy
export function randomId() {
	const chars = "abcdefghijklmnopqrstuvwxyz0123456789"
	let id = ""
	for (let i = 0; i < 20; i++)
		id += chars[Math.floor(Math.random() * chars.length)]
	return id
}
