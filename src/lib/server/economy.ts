const economyUrl = "localhost:2009"

export const getBalance = async (userId: string) =>
	+(await (await fetch(`${economyUrl}/balance/${userId}`)).text())

export async function stipend(userId: string) {
	try {
		const res = await fetch(`${economyUrl}/stipend/${userId}`, {
			method: "POST",
		})
		return res.status === 200
	} catch {
		return false
	}
}
