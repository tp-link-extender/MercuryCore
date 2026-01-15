import { db, Record } from "$lib/server/surreal"
import usersQuery from "$lib/server/users.surql"

const economyUrl = "localhost:2009"

export const economyConnFailed = "Cannot connect to Economy service"

export type ReturnValue<T> = Promise<{ ok: true; value: T } | { ok: false }>
export type ReturnErr = { ok: true } | { ok: false; msg: string }

const tryFetch =
	<T>(transform: (res: Response) => Promise<T>) =>
	async (
		f: typeof globalThis.fetch,
		url: string
	): Promise<ReturnValue<T>> => {
		try {
			const res = await f(url)
			if (!res.ok) return { ok: false }
			return { ok: true, value: await transform(res) }
		} catch {
			return { ok: false }
		}
	}

const tryFetchValue = tryFetch(async res => +(await res.text()))
const tryFetchJson = <T>() => tryFetch(async res => (await res.json()) as T) // type assertion much?¿

export const getStipend = (f: typeof globalThis.fetch) =>
	tryFetchValue(f, `${economyUrl}/currentStipend`)
export const getBalance = (f: typeof globalThis.fetch, user: string) =>
	tryFetchValue(f, `${economyUrl}/balance/${user}`)

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

export const getTransactions = (f: typeof globalThis.fetch, user: string) =>
	tryFetchJson<ReceivedTx[]>()(f, `${economyUrl}/transactions/${user}`)
export const getAdminTransactions = (f: typeof globalThis.fetch) =>
	tryFetchJson<ReceivedTx[]>()(f, `${economyUrl}/transactions`)

// doin nothing with returns rn
export async function stipend(f: typeof globalThis.fetch, To: string) {
	try {
		await f(`${economyUrl}/stipend/${To}`, { method: "post" })
	} catch {}
}

export async function transact(
	f: typeof globalThis.fetch,
	From: string,
	To: string,
	Amount: number,
	Note: string,
	Link: string,
	Returns: { [_: number]: number }
): Promise<ReturnErr> {
	try {
		const res = await f(`${economyUrl}/transact`, {
			method: "post",
			body: JSON.stringify({ From, To, Amount, Note, Link, Returns }),
		})
		if (res.status === 200) return { ok: true }
		return { ok: false, msg: await res.text() }
	} catch (err) {
		const e = err as Error
		return { ok: false, msg: e.message }
	}
}

async function burn(
	f: typeof globalThis.fetch,
	From: string,
	Amount: number,
	Note: string,
	Link: string,
	Returns: { [_: number]: number }
): Promise<ReturnErr> {
	try {
		// Who's not entertained by my pain
		// Who aint cash a cheque off my name
		// When my campaign turned to a cam-pain
		// We got $2.5 trillion stored on the blockchain
		// Uh, ₿urn ₿aby ₿urn
		const res = await f(`${economyUrl}/burn`, {
			method: "post",
			body: JSON.stringify({ From, Amount, Note, Link, Returns }),
		})
		if (res.status === 200) return { ok: true }
		return { ok: false, msg: await res.text() }
	} catch (err) {
		const e = err as Error
		return { ok: false, msg: e.message }
	}
}

export const fee = 0.1
const getFeeBasedPrice = (multiplier: number): number =>
	Math.round(fee * multiplier * 1e6)

export const getAssetPrice = () => getFeeBasedPrice(75)
export const getGroupPrice = () => getFeeBasedPrice(50)
// export const getPlacePrice = () => getFeeBasedPrice(50)

export async function createAsset(
	f: typeof globalThis.fetch,
	To: string,
	id: number,
	name: string,
	slug: string
): Promise<ReturnErr> {
	const price = getAssetPrice()
	return await burn(
		f,
		To,
		price,
		`Created asset ${name}`,
		`/catalog/${id}/${slug}`,
		{}
	)
}

// export async function createPlace(
// 	f: typeof globalThis.fetch,
// 	To: string,
// 	id: number,
// 	name: string,
// 	slug: string
// ): Promise<ReturnErr> {
// 	const price = getPlacePrice()
// 	return await burn(
// 		fee,
// 		To,
// 		price,
// 		`Created place ${name}`,
// 		`/place/${id}/${slug}`,
// 		{}
// 	)
// }

export async function createGroup(
	f: typeof globalThis.fetch,
	To: string,
	name: string
): Promise<ReturnErr> {
	const price = getGroupPrice()
	return await burn(
		f,
		To,
		price,
		`Created group ${name}`,
		`/groups/${name}`,
		{}
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
