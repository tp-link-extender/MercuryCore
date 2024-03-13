import { mquery, query, squery, surql, type Param } from "./surreal"

type TextContent = {
	text: string
	updated: Date
}

type Infer = {
	application: {
		id: string
		created: Date
		discordId: number
		status: "Pending" | "Accepted" | "Declined" | "Banned"
		reason?: string
		response: string[]
		reviewed?: Date
	}
	asset: {
		id: string
		created: Date
		description: TextContent
		name: string
		price: number
		type: number
		updated: Date
		visibility: "Pending" | "Visible" | "Moderated"
		// in: string
	}
	assetCache: {
		id: string
		assetModified: Date
		created: Date
		data: string
	}
	assetComment: {
		id: string
		content: TextContent
		pinned: boolean
		posted: Date
		visibility: "Visible" | "Moderated" | "Deleted"
	}
	auditLog: {
		id: string
		action: "Account" | "Administration" | "Economy" | "Moderation"
		note: string
		time: Date
		user: string
	}
	banner: {
		id: string
		active: boolean
		bgColour: string
		body: string
		creator: string
		deleted: boolean
		textLight: boolean
	}
	created: {
		id: string
		// in: string
		// out: string
	}
	dislikes: {
		id: string
		time: Date
		// in: string
		// out: string
	}
	follows: {
		id: string
		time: Date
		// in: string
		// out: string
	}
	forumCategory: {
		id: string
		name: string
		description: string
		// in: string
	}
	forumPost: {
		id: string
		content: TextContent
		pinned: boolean
		posted: Date
		title: string
		visibility: "Visible" | "Moderated" | "Deleted"
		// in: string
		// out: string
	}
	forumReply: {
		id: string
		content: TextContent
		pinned: boolean
		posted: Date
		visibility: "Visible" | "Moderated" | "Deleted"
	}
	friends: {
		id: string
		time: Date
		// in: string
		// out: string
	}
	hasSession: {
		id: string
		// in: string
		// out: string
	}
	imageAsset: {
		id: string
		// in: string
		// out: string
	}
	in: {
		id: string
		// in: string
		// out: string
	}
	likes: {
		id: string
		time: Date
		// in: string
		// out: string
	}
	notification: {
		id: string
		note: string
		read: boolean
		relativeId: string
		time: Date
		type: "NewFriend" | "FriendRequest" | "Follower"
	}
	owns: {
		id: string
		// in: string
		// out: string
	}
	place: {
		id: string
		created: Date
		deleted: boolean
		description: TextContent
		maxPlayers: number
		name: string
		privateServer?: boolean
		privateTicket: string
		serverIP: string
		serverPing: number
		serverPort: number
		serverTicket: string
		updated: Date
		// in: string
	}
	playing: {
		id: string
		ping: number
		valid: boolean
		// in: string
		// out: string
	}
	posted: {
		id: string
		// in: string
		// out: string
	}
	recentlyWorn: {
		id: string
		time: Date
		// in: string
		// out: string
	}
	regKey: {
		id: string
		created: Date
		expiry?: Date
		usesLeft: number
		// in: string
	}
	render: {
		id: string
		completed: Date
		created: Date
		relativeId: number
		status: "Rendering" | "Completed" | "Error"
		type: "Avatar" | "Clothing"
	}
	replyToAsset: {
		id: string
		// in: string
		// out: string
	}
	replyToComment: {
		id: string
		// in: string
		// out: string
	}
	replyToPost: {
		id: string
		// in: string
		// out: string
	}
	replyToReply: {
		id: string
		// in: string
		// out: string
	}
	request: {
		id: string
		// in: string
		// out: string
	}
	session: {
		id: string
		expiresAt: Date
		// in: string
	}
	statusPost: {
		id: string
		content: TextContent
		posted: Date
		visibility: "Visible" | "Moderated" | "Deleted"
		// in: string
	}
	stuff: {
		id: string
		asset?: number
		ids: number
		place: number
		taxRate?: number
		dailyStipend?: number
		stipendTime?: number
		user: number
	}
	thumbnailCache: {
		id: string
		url: string
	}
	transaction: {
		id: string
		amountSent: number
		link: string
		note: string
		taxRate: number
		time: Date
		// in: string
		// out: string
	}
	used: {
		id: string
		// in: string
		// out: string
	}
	user: {
		id: string
		bio: TextContent
		bodyColours: {
			Head: number
			LeftArm: number
			LeftLeg: number
			RightArm: number
			RightLeg: number
			Torso: number
		}
		created: Date
		currency: number
		currencyCollected: Date
		email: string
		hashedPassword: string
		lastOnline: Date
		number: number
		permissionLevel: number
		status: "Online" | "Offline"
		theme: "standard"
		username: string
	}
	wearing: {
		id: string
		time: Date
		// in: string
		// out: string
	}
}
type Tables = {
	[K in keyof Infer]: { id: string; metaId: string } & Infer[K]
}

type Table = keyof Tables

// Surreal specific functions and stuff that can't be passed in from the table
const defaultTypes: Partial<{ [k in Table]: string }> = {
	auditLog: surql`{
		time: time::now()
	}`,
}

function thing<T extends Table>(table: T) {
	const tid = (id: string | number) =>
		typeof id === "string" ? `${table}:⟨${id}⟩` : `${table}:${id}`
	const delet = (id?: string) =>
		id
			? query<never>(surql`DELETE $id`, { id: tid(id) })
			: query<never>(surql`DELETE $table`, { table })

	type Selectable = keyof Tables[T]
	type Props = Partial<{ [K in Selectable]: Tables[T][K] }>

	async function create(
		idOrProps: string | Props,
		props: Props = {}
	): Promise<Selectable> {
		const defaults = defaultTypes[table]

		if (typeof idOrProps === "string") {
			if (defaults) {
				const returns = await mquery<Selectable[]>(
					surql`
						LET $object = CREATE $id CONTENT $props;
						UPDATE $object MERGE ${defaults};
						SELECT * FROM $object.id`,
					{
						id: tid(idOrProps),
						props,
					}
				)
				return returns[2]
			}

			return await squery(surql`CREATE $id CONTENT $props`, {
				id: tid(idOrProps),
				props,
			})
		}

		// type::table() for "Can not execute CREATE statement using value ''whatever''"
		if (defaults) {
			const returns = await mquery<Selectable[]>(
				surql`
					LET $object = CREATE type::table($table) CONTENT $props;
					UPDATE $object MERGE ${defaults};
					SELECT * FROM $object.id`,
				{
					table,
					props: idOrProps,
				}
			)
			return returns[2]
		}

		return await squery(surql`CREATE type::table($table) CONTENT $props`, {
			table,
			props: idOrProps,
		})
	}

	const merge = (id: string, props: Props) =>
		squery<Props>(surql`UPDATE $id MERGE $props`, {
			id: tid(id),
			props,
		})

	// Should error when selecting a field that wasn't specified
	// eg. select1("created").updated should error
	// if toSelect is ["*"], return all fields
	// We're in the Typescript zone now, nerds
	type ReturnProps<F extends Selectable> = F[] extends ["*"]
		? Tables[T]
		: { [K in F]: Tables[T][K] }

	// if a field is "metaId", return the id as "id"
	type Return<F extends Selectable> = ReturnProps<F> extends {
		metaId: string
	}
		? Omit<ReturnProps<F>, "metaId"> & { id: string }
		: ReturnProps<F>

	const transform = <F extends Selectable>(selections: F[] | ["*"]) =>
		// replace "metaId" with "meta::id(id) AS id"
		selections
			.map(s => (s === "metaId" ? "meta::id(id) AS id" : s))
			.join(", ")

	const select1 = <F extends Selectable>(
		id: string,
		...toSelect: F[] | ["*"]
	) =>
		squery<Return<F>>(surql`SELECT ${transform(toSelect)} FROM $id`, {
			id: tid(id),
		})

	const select = <F extends Selectable>(...toSelect: F[] | ["*"]) =>
		query<Return<F>>(surql`SELECT ${transform(toSelect)} FROM $table`, {
			table,
		})

	const find = (id: string | number) =>
		query(surql`!!SELECT 1 FROM $id`, {
			id: tid(id),
		}) as unknown as Promise<boolean>

	function where(conds: string[], extraProps: { [k: string]: Param } = {}) {
		const conditions = conds.join(" AND ")

		const select1Conditions = <F extends Selectable>(
			id: string,
			...toSelect: F[]
		) =>
			squery(
				surql`SELECT ${transform(
					toSelect
				)} FROM $id WHERE ${conditions}`,
				{ id: tid(id), ...extraProps }
			) as Promise<Return<F>>

		const selectConditions = <F extends Selectable>(
			...toSelect: F[] | ["*"]
		) =>
			query(
				surql`SELECT ${transform(
					toSelect
				)} FROM type::table($table) WHERE ${conditions}`,
				{ table, ...extraProps }
			) as Promise<Return<F>[]>

		const find1Conditions = (id: string) =>
			squery<boolean>(surql`!!SELECT 1 FROM $id WHERE ${conditions}`, {
				id: tid(id),
				...extraProps,
			})

		const findConditions = () =>
			squery<boolean>(
				surql`!!SELECT 1 FROM type::table($table) WHERE ${conditions}`,
				{ table, ...extraProps }
			)

		return {
			select1: select1Conditions,
			select: selectConditions,
			find1: find1Conditions,
			find: findConditions,
		}
	}

	return {
		id: tid,
		delete: delet,
		create,
		merge,
		where,
		select1,
		select,
		find,
	}
}

export const application = thing("application")
export const asset = thing("asset")
export const assetCache = thing("assetCache")
export const assetComment = thing("assetComment")
export const auditLog = thing("auditLog")
export const banner = thing("banner")
export const created = thing("created")
export const dislikes = thing("dislikes")
export const follows = thing("follows")
export const forumCategory = thing("forumCategory")
export const forumPost = thing("forumPost")
export const forumReply = thing("forumReply")
export const friends = thing("friends")
export const hasSession = thing("hasSession")
export const imageAsset = thing("imageAsset")
// export const in = thing("in")
export const likes = thing("likes")
export const notification = thing("notification")
export const owns = thing("owns")
export const place = thing("place")
export const playing = thing("playing")
export const posted = thing("posted")
export const recentlyWorn = thing("recentlyWorn")
export const regKey = thing("regKey")
export const render = thing("render")
export const replyToAsset = thing("replyToAsset")
export const replyToComment = thing("replyToComment")
export const replyToPost = thing("replyToPost")
export const replyToReply = thing("replyToReply")
export const request = thing("request")
export const session = thing("session")
export const statusPost = thing("statusPost")
export const stuff = thing("stuff")
export const thumbnailCache = thing("thumbnailCache")
export const transaction = thing("transaction")
export const used = thing("used")
export const user = thing("user")
export const wearing = thing("wearing")
