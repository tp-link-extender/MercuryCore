import type { TransferWithID } from "economy/economy"
import * as Econ from "economy/types"
import type { GroupData, OwnerData, SourceData, UserData } from "$lib/economy"
import ownersQuery from "$lib/server/owners.surql"
import { db, Record } from "$lib/server/surreal"

export const PlacePrice = 10
export const GroupPrice = 10
export const LimitedSourcePrice = 100
export const UnlimitedSourcePrice = 10
export const StipendAmount = 10

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

// better code than previously... i guess. whatever
export async function ownerData(list: TransferWithID[]): Promise<OwnerData> {
	const owners = [
		...list.map(tf => tf.Transfer.Send0.Owner),
		...list.map(tf => tf.Transfer.Send1.Owner),
	].filter(o => o !== null)

	const [users, groups, sources] = await db.query<
		[UserData[], GroupData[], SourceData[]]
	>(ownersQuery, {
		usersList: owners
			.filter(o => o instanceof Econ.User)
			.map(u => Record("user", u.ID)),
		groupsList: owners
			.filter(o => o instanceof Econ.Group)
			.map(g => Record("group", g.ID)),
		assetsList: owners
			.filter(Econ.IsSource)
			.map(s => Record("asset", s.ID)),
	})

	return {
		users: Object.fromEntries(users.map(u => [u.id, u])),
		groups: Object.fromEntries(groups.map(g => [g.id, g])),
		sources: Object.fromEntries(sources.map(s => [s.id, s])),
	}
}
