const economyUrl = "localhost:2009"

export async function getBalance(userId: string) {
	try {
		const req = await fetch(`${economyUrl}/balance/${userId}`)
		return { ok: true, value: +(await req.text()) }
	} catch (err) {
		return { ok: false, value: 0 }
	}
}

export async function getStipend() {
	try {
		const req = await fetch(`${economyUrl}/currentStipend`)
		return { ok: true, value: +(await req.text()) }
	} catch (err) {
		return { ok: false, value: 0 }
	}
}

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
