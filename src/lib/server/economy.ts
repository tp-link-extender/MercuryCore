const economyUrl = "localhost:2009"

export async function getBalance(userId: string) {
	const res = await fetch(`${economyUrl}/balance/${userId}`)
	return +(await res.text())
}
