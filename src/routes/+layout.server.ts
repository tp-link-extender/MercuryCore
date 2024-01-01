import fs from "fs"
import { query, squery, surql } from "$lib/server/surreal"

let lines = "0"

// extract the line count from the stupid file that scc outputs
try {
	lines =
		fs
			.readFileSync("data/lines", "utf-8")
			.split("\n")
			.filter(l => l.startsWith("  n_lines"))[0]
			.split(" ")
			.pop() || "0"
} catch (e) {
	console.error(e)
}

export async function load({ request, locals }) {
	const session = await locals.auth.validate(),
		user = session?.user
	// Not authorise function, as we don't want
	// to redirect to login page if not logged in

	let notifications
	if (session && user) {
		const notifications1 = await query<{
			id: string
			in: string
			note: string
			out: string
			read: boolean
			relativeId: string
			sender: {
				number: number
				status: "Playing" | "Online" | "Offline"
				username: string
			}
			time: string
			type: string
		}>(
			surql`
				SELECT
					*,
					meta::id(id) AS id,
					(SELECT
						number,
						status,
						username
					FROM <-user)[0] AS sender
				FROM notification
				WHERE out = $user
				ORDER BY time DESC`,
			{
				user: `user:${user.id}`,
			}
		)

		// Make type relativeId optional so we can delete it later
		type Optional<T, K extends keyof T> = Omit<T, K> & Partial<Pick<T, K>>
		// i told myself i would never write types like this
		const notifications2: (Optional<
			(typeof notifications1)[0],
			"relativeId"
		> & { link?: string })[] = notifications1

		for (const i of notifications2) {
			switch (i.type) {
				case "AssetApproved":
				case "FriendRequest":
				case "Follower":
				case "NewFriend":
					i.link = `/user/${i.sender.number}`
					break

				case "AssetComment":
				case "AssetCommentReply":
					const comment = await squery<{
						id: string
						parentAsset: {
							id: string
							name: string
						}
					}>(
						surql`
							SELECT
								*,
								meta::id(id) AS id,
								(SELECT
									meta::id(id) AS id,
									name
								FROM ->replyToAsset->asset)[0] AS parentAsset
							FROM $comment`,
						{ comment: `assetComment:${i.relativeId}` }
					)
					if (!comment) break

					i.link = `/avatarshop/${comment.parentAsset.id}/${comment.parentAsset.name}/${comment.id}`
					break

				case "ForumPostReply":
				case "ForumReplyReply":
					const reply = await squery<{
						id: string
						parentPost: {
							categoryName: string
							id: string
						}
					}>(
						surql`
							SELECT
								meta::id(id) AS id,
								(SELECT
									meta::id(id) AS id,
									(->in->forumCategory)[0].name as categoryName
								FROM ->replyToPost[0]->forumPost)[0] AS parentPost
							FROM $reply`,
						{ reply: `forumReply:${i.relativeId}` }
					)
					if (!reply) break

					i.link = `/forum/${reply.parentPost.categoryName.toLowerCase()}/${
						reply.parentPost.id
					}/${reply.id}`
					break

				case "ForumMention":
				case "ForumPost":
					const post = await squery<{
						category: {
							name: string
						}
					}>(
						surql`
							SELECT
								(SELECT name
								FROM ->in->forumCategory) AS category
							FROM $forumPost`,
						{
							forumPost: `forumPost:${i.relativeId}`,
						}
					)
					if (!post) break

					i.link = `/forum/${post.category.name.toLowerCase()}/${
						i.relativeId
					}`
					break

				case "ItemPurchase":
					i.link = `/avatarshop/${i.relativeId}`
			}
			delete i.relativeId
		}
		notifications = notifications2
	}

	return {
		banners: await query<{
			bgColour: string
			body: string
			id: string
			textLight: boolean
		}>(surql`
			SELECT
				body,
				bgColour,
				textLight,
				meta::id(id) AS id
			OMIT deleted
			FROM banner
			WHERE deleted = false AND active = true`),
		user,
		notifications: notifications || [],
		url: request.url,
		lines, // footer thing
	}
}
