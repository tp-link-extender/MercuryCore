const economyUrl = "localhost:2009"

export const economyConnFailed = "Cannot connect to economy service"

type ReturnValue<T> = Promise<{ ok: true; value: T } | { ok: false }>
type ReturnErr = { ok: true } | { ok: false; msg: string }

const tryFetch =
	<T>(transform: (req: Response) => Promise<T>) =>
	async (url: string): Promise<ReturnValue<T>> => {
		try {
			const req = await fetch(url)
			return { ok: true, value: await transform(req) }
		} catch {
			return { ok: false }
		}
	}

const tryFetchValue = tryFetch(async req => +(await req.text()))
const tryFetchJson = <T>() => tryFetch(async req => (await req.json()) as T) // type assertion much?¿

export const getCurrentFee = () => tryFetchValue(`${economyUrl}/currentFee`)
export const getStipend = () => tryFetchValue(`${economyUrl}/currentStipend`)
export const getBalance = (user: string) =>
	tryFetchValue(`${economyUrl}/balance/${user}`)

type BaseTx = {
	Note: string
	Time: number
	Id: string
}

type TxTypes =
	| {
			Type: "Transaction"
			From: string
			To: string
			Amount: number
			Link: string
			Returns: number[]
			Fee: number
	  }
	| {
			Type: "Mint"
			To: string
			Amount: number
	  }
	| {
			Type: "Burn"
			From: string
			Amount: number
			Link: string
			Returns: number[]
	  }

type ReceivedTx = BaseTx & TxTypes

export const getTransactions = (user: string) =>
	tryFetchJson<ReceivedTx[]>()(`${economyUrl}/transactions/${user}`)
export const getAdminTransactions = () =>
	tryFetchJson<ReceivedTx[]>()(`${economyUrl}/transactions`)

// doin nothing with returns rn
export async function stipend(To: string) {
	try {
		await fetch(`${economyUrl}/stipend/${To}`, {
			method: "POST",
		})
	} catch {}
}

export async function transact(
	From: string,
	To: string,
	Amount: number,
	Note: string,
	Link: string,
	Returns: number[]
): Promise<ReturnErr> {
	try {
		const res = await fetch(`${economyUrl}/transact`, {
			method: "POST",
			body: JSON.stringify({ From, To, Amount, Note, Link, Returns }),
		})
		if (res.status === 200) return { ok: true }
		return { ok: false, msg: await res.text() }
	} catch (err) {
		const e = err as Error
		return { ok: false, msg: e.message }
	}
}

export async function burn(
	From: string,
	Amount: number,
	Note: string,
	Link: string,
	Returns: number[]
): Promise<ReturnErr> {
	try {
		const res = await fetch(`${economyUrl}/burn`, {
			method: "POST",
			body: JSON.stringify({ From, Amount, Note, Link, Returns }),
		})
		if (res.status === 200) return { ok: true }
		return { ok: false, msg: await res.text() }
	} catch (err) {
		const e = err as Error
		return { ok: false, msg: e.message }
	}
}

async function geFeeBasedPrice(
	multiplier: number
): Promise<{ ok: true; value: number } | { ok: false; msg: string }> {
	const currentFee = await getCurrentFee()
	if (!currentFee.ok) return { ok: false, msg: economyConnFailed }
	const value = Math.round(currentFee.value * multiplier * 1e6) // increases when economy 2 large
	return { ok: true, value }
}

export const getAssetPrice = () => geFeeBasedPrice(75)
export const getGroupPrice = () => geFeeBasedPrice(50)
export const getPlacePrice = () => geFeeBasedPrice(50)

export async function createAsset(
	To: string,
	id: number,
	name: string,
	slug: string
): Promise<ReturnErr> {
	const price = await getAssetPrice()
	if (!price.ok) return price
	return await burn(
		To,
		price.value,
		`Created asset ${name}`,
		`/avatarshop/${id}/${slug}`,
		[id]
	)
}

export async function createPlace(
	To: string,
	id: number,
	name: string,
	slug: string
): Promise<ReturnErr> {
	const price = await getPlacePrice()
	if (!price.ok) return price
	return await burn(
		To,
		price.value,
		`Created place ${name}`,
		`/place/${id}/${slug}`,
		[id]
	)
}

export async function createGroup(
	To: string,
	name: string
): Promise<ReturnErr> {
	const price = await getGroupPrice()
	if (!price.ok) return price
	return await burn(
		To,
		price.value,
		`Created group ${name}`,
		`/groups/${name}`,
		[]
	)
}
