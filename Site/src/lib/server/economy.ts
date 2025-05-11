import { Record, db } from "$lib/server/surreal"
import usersQuery from "$lib/server/users.surql"

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

async function getFeeBasedPrice(
	multiplier: number
): Promise<{ ok: true; value: number } | { ok: false; msg: string }> {
	const currentFee = await getCurrentFee()
	if (!currentFee.ok) return { ok: false, msg: economyConnFailed }
	const value = Math.round(currentFee.value * multiplier * 1e6) // increases when economy 2 large
	return { ok: true, value }
}

export const getAssetPrice = () => getFeeBasedPrice(75)
export const getGroupPrice = () => getFeeBasedPrice(50)
export const getPlacePrice = () => getFeeBasedPrice(50)

export async function createAsset(
	To: string,
	id: string,
	name: string,
	slug: string
): Promise<ReturnErr> {
	const price = await getAssetPrice()
	if (!price.ok) return price
	return await burn(
		To,
		price.value,
		`Created asset ${name}`,
		`/catalog/${id}/${slug}`,
		[id]
	)
}

export async function createPlace(
	To: string,
	id: string,
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
		[]
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

export async function transformTransactions(list: ReceivedTx[]) {
	// Awful no-good terrible code for transforming this stuff. Feels like we're back in the double-database days of Mercury 2

	const users = new Set<string>()
	for (const tx of list) {
		if (tx.Type !== "Mint") users.add(tx.From)
		if (tx.Type !== "Burn") users.add(tx.To)
	}
	const [queryUsers] = await db.query<(BasicUser & { id: string })[][]>(
		usersQuery,
		{ usersList: Array.from(users).map(u => Record("user", u)) }
	)

	const idsMap = new Map<string, BasicUser>()
	const usersMap = new Map<string, BasicUser>()
	for (const user of queryUsers) {
		idsMap.set(user.id, {
			username: user.username,
			status: user.status,
		})
		usersMap.set(user.username, {
			username: user.username,
			status: user.status,
		})
	}

	for (const tx of list) {
		if (tx.Type !== "Mint") tx.From = idsMap.get(tx.From)?.username || ""
		if (tx.Type !== "Burn") tx.To = idsMap.get(tx.To)?.username || ""
	}

	return {
		transactions: list,
		users: Object.fromEntries(usersMap),
	}
}
