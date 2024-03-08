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
		action: z.enum(["Administration", "Moderation"]),
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
	const delet = () => query(surql`DELETE $table`, { table }) as Promise<[]>

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

	const get = (id: string) => {
		const delet = () =>
			query(surql`DELETE $id`, { id: tid(id) }) as Promise<[]>

		// Should error when selecting a field that wasn't specified
		// eg. select1("created").updated should error

		// We're in the Typescript zone now, nerds
		type Return<F extends Selectable> = F[] extends ["*"]
			? Tables[T]
			: { [K in F]: Tables[T][K] }

		const select = <F extends Selectable>(...toSelect: F[] | ["*"]) =>
			// if toSelect is ["*"], return all fields
			squery<Return<F>>(surql`SELECT ${toSelect.join(", ")} FROM $id`, {
				id: tid(id),
			})
		return {
			delete: delet,
			select,
		}
	}

	return {
		id: tid,
		delete: delet,
		create,
		merge,
		get,
	}
}

const application = thing("application")
const asset = thing("asset")
const assetCache = thing("assetCache")
const assetComment = thing("assetComment")
const auditLog = thing("auditLog")
const banner = thing("banner")
const created = thing("created")
const dislikes = thing("dislikes")
const follows = thing("follows")
const forumCategory = thing("forumCategory")
const forumPost = thing("forumPost")
const forumReply = thing("forumReply")
const friends = thing("friends")
const hasSession = thing("hasSession")
const imageAsset = thing("imageAsset")
// const in = thing("in")
const likes = thing("likes")
const notification = thing("notification")
const owns = thing("owns")
const place = thing("place")
const playing = thing("playing")
const posted = thing("posted")
const recentlyWorn = thing("recentlyWorn")
const regKey = thing("regKey")
const render = thing("render")
const replyToAsset = thing("replyToAsset")
const replyToComment = thing("replyToComment")
const replyToPost = thing("replyToPost")
const replyToReply = thing("replyToReply")
const request = thing("request")
const session = thing("session")
const statusPost = thing("statusPost")
const stuff = thing("stuff")
const thumbnailCache = thing("thumbnailCache")
const transaction = thing("transaction")
const used = thing("used")
const user = thing("user")
const wearing = thing("wearing")

export {
	// bruh bruh ts bruh
	application,
	asset,
	assetCache,
	assetComment,
	auditLog,
	banner,
	created,
	dislikes,
	follows,
	forumCategory,
	forumPost,
	forumReply,
	friends,
	hasSession,
	imageAsset,
	// in,
	likes,
	notification,
	owns,
	place,
	playing,
	posted,
	recentlyWorn,
	regKey,
	render,
	replyToAsset,
	replyToComment,
	replyToPost,
	replyToReply,
	request,
	session,
	statusPost,
	stuff,
	thumbnailCache,
	transaction,
	used,
	user,
	wearing,
}
