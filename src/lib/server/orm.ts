import { mquery, query, squery, surql } from "./surreal"
import { z } from "zod"

const textContent = z.object({
	text: z.string(),
	updated: z.date(),
})

const tables = z.object({
	application: z.object({
		id: z.string(),
		created: z.date(),
		discordId: z.number(),
		status: z.enum(["Pending", "Accepted", "Declined", "Banned"]),
		reason: z.string().optional(),
		response: z.array(z.string()),
		reviewed: z.date().optional(),
	}),
	asset: z.object({
		id: z.string(),
		created: z.date(),
		description: textContent,
		name: z.string(),
		price: z.number(),
		type: z.number(),
		updated: z.date(),
		visibility: z.enum(["Pending", "Visible", "Moderated"]),
		// in: z.string(),
	}),
	assetCache: z.object({
		id: z.string(),
		assetModified: z.date(),
		created: z.date(),
		data: z.string(),
	}),
	assetComment: z.object({
		id: z.string(),
		content: textContent,
		pinned: z.boolean(),
		posted: z.date(),
		visibility: z.enum(["Visible", "Moderated", "Deleted"]),
	}),
	auditLog: z.object({
		id: z.string(),
		action: z.enum(["Account", "Administration", "Economy", "Moderation"]),
		note: z.string(),
		time: z.date(),
		user: z.string(),
	}),
	banner: z.object({
		id: z.string(),
		active: z.boolean(),
		bgColour: z.string(),
		body: z.string(),
		creator: z.string(),
		deleted: z.boolean(),
		textLight: z.boolean(),
	}),
	created: z.object({
		id: z.string(),
		// in: z.string(),
		// out: z.string(),
	}),
	dislikes: z.object({
		id: z.string(),
		time: z.date(),
		// in: z.string(),
		// out: z.string(),
	}),
	follows: z.object({
		id: z.string(),
		time: z.date(),
		// in: z.string(),
		// out: z.string(),
	}),
	forumCategory: z.object({
		id: z.string(),
		name: z.string(),
		description: z.string(),
		// in: z.string(),
	}),
	forumPost: z.object({
		id: z.string(),
		content: textContent,
		pinned: z.boolean(),
		posted: z.date(),
		title: z.string(),
		visibility: z.enum(["Visible", "Moderated", "Deleted"]),
		// in: z.string(),
		// out: z.string(),
	}),
	forumReply: z.object({
		id: z.string(),
		content: textContent,
		pinned: z.boolean(),
		posted: z.date(),
		visibility: z.enum(["Visible", "Moderated", "Deleted"]),
	}),
	friends: z.object({
		id: z.string(),
		time: z.date(),
		// in: z.string(),
		// out: z.string(),
	}),
	hasSession: z.object({
		id: z.string(),
		// in: z.string(),
		// out: z.string(),
	}),
	imageAsset: z.object({
		id: z.string(),
		// in: z.string(),
		// out: z.string(),
	}),
	in: z.object({
		id: z.string(),
		// in: z.string(),
		// out: z.string(),
	}),
	likes: z.object({
		id: z.string(),
		time: z.date(),
		// in: z.string(),
		// out: z.string(),
	}),
	notification: z.object({
		id: z.string(),
		note: z.string(),
		read: z.boolean(),
		relativeId: z.string(),
		time: z.date(),
		type: z.enum(["NewFriend", "FriendRequest", "Follower"]),
	}),
	owns: z.object({
		id: z.string(),
		// in: z.string(),
		// out: z.string(),
	}),
	place: z.object({
		id: z.string(),
		created: z.date(),
		deleted: z.boolean(),
		description: textContent,
		maxPlayers: z.number(),
		name: z.string(),
		privateServer: z.boolean().optional(),
		serverIP: z.string(),
		serverPing: z.number(),
		serverPort: z.number(),
		serverTicket: z.string(),
		updated: z.date(),
		// in: z.string(),
	}),
	playing: z.object({
		id: z.string(),
		ping: z.number(),
		valid: z.boolean(),
		// in: z.string(),
		// out: z.string(),
	}),
	posted: z.object({
		id: z.string(),
		// in: z.string(),
		// out: z.string(),
	}),
	recentlyWorn: z.object({
		id: z.string(),
		time: z.date(),
		// in: z.string(),
		// out: z.string(),
	}),
	regKey: z.object({
		id: z.string(),
		created: z.date(),
		expiry: z.date().optional(),
		usesLeft: z.number(),
		// in: z.string(),
	}),
	render: z.object({
		id: z.string(),
		completed: z.date(),
		created: z.date(),
		relativeId: z.number(),
		status: z.enum(["Rendering", "Completed", "Error"]),
		type: z.enum(["Avatar", "Clothing"]),
	}),
	replyToAsset: z.object({
		id: z.string(),
		// in: z.string(),
		// out: z.string(),
	}),
	replyToComment: z.object({
		id: z.string(),
		// in: z.string(),
		// out: z.string(),
	}),
	replyToPost: z.object({
		id: z.string(),
		// in: z.string(),
		// out: z.string(),
	}),
	replyToReply: z.object({
		id: z.string(),
		// in: z.string(),
		// out: z.string(),
	}),
	request: z.object({
		id: z.string(),
		// in: z.string(),
		// out: z.string(),
	}),
	session: z.object({
		id: z.string(),
		expiresAt: z.date(),
		// in: z.string(),
	}),
	statusPost: z.object({
		id: z.string(),
		content: textContent,
		posted: z.date(),
		visibility: z.enum(["Visible", "Moderated", "Deleted"]),
		// in: z.string(),
	}),
	stuff: z.object({
		id: z.string(),
		asset: z.number().optional(),
		ids: z.number(),
		place: z.number(),
		taxRate: z.number().optional(),
		user: z.number(),
	}),
	thumbnailCache: z.object({
		id: z.string(),
		url: z.string(),
	}),
	transaction: z.object({
		id: z.string(),
		amountSent: z.number(),
		link: z.string(),
		note: z.string(),
		taxRate: z.number(),
		time: z.date(),
		// in: z.string(),
		// out: z.string(),
	}),
	used: z.object({
		id: z.string(),
		// in: z.string(),
		// out: z.string(),
	}),
	user: z.object({
		id: z.string(),
		bio: z.object({
			text: z.string(),
			updated: z.date(),
		}),
		bodyColours: z.object({
			Head: z.number(),
			LeftArm: z.number(),
			LeftLeg: z.number(),
			RightArm: z.number(),
			RightLeg: z.number(),
			Torso: z.number(),
		}),
		created: z.date(),
		currency: z.number(),
		currencyCollected: z.date(),
		email: z.string(),
		hashedPassword: z.string(),
		lastOnline: z.date(),
		number: z.number(),
		permissionLevel: z.number(),
		status: z.enum(["Online", "Offline"]),
		theme: z.enum(["standard"]),
		username: z.string(),
	}),
	wearing: z.object({
		id: z.string(),
		time: z.date(),
		// in: z.string(),
		// out: z.string(),
	}),
})

type Tables = z.infer<typeof tables>
type Table = keyof Tables

// Surreal specific functions and stuff that can't be passed in from the table
const defaultTypes: Partial<{ [k in Table]: string }> = {
	auditLog: surql`{
		time: time::now()
	}`,
}

function thing<T extends Table>(table: T) {
	const tid = (id: string) => `${table}:⟨${id}⟩`
	const delet = (id?: string) =>
		id
			? query<never>(surql`DELETE $id`, { id: tid(id) })
			: query<never>(surql`DELETE $table`, { table })

	type Selectable = keyof Tables[T]
	type Props = Partial<{
		[K in Selectable]: Tables[T][K]
	}>

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

	// We're in the Typescript zone now, nerds
	type Return<F extends Selectable> = F[] extends ["*"]
		? Tables[T]
		: { [K in F]: Tables[T][K] }

	// const select = <F extends Selectable>(...toSelect: F[] | ["*"]) =>
	// 	// if toSelect is ["*"], return all fields
	// 	squery<Return<F>>(surql`SELECT ${toSelect.join(", ")} FROM $id`, {
	// 		id: tid(id),
	// 	})

	// const from = (id: string) => {
	// 	const select = <F extends Selectable>(...toSelect: F[] | ["*"]) =>
	// 		// if toSelect is ["*"], return all fields
	// 		squery<Return<F>>(surql`SELECT ${toSelect.join(", ")} FROM $id`, {
	// 			id: tid(id),
	// 		})
	// 	return {
	// 		delete: delet,
	// 		select,
	// 	}
	// }

	const find = (id: string) =>
		query(surql`!!SELECT 1 FROM $id`, {
			id: tid(id),
		}) as unknown as Promise<boolean>

	return {
		id: tid,
		delete: delet,
		create,
		merge,
		find,
		// from,
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
