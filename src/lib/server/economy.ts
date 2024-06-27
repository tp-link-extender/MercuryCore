const economyUrl = "localhost:2009"

export async function getBalance(userNumber: number) {
	const res = await fetch(`${economyUrl}/balance/${userNumber}`)
	return +(await res.text())
}
