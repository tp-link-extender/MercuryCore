// Functions for selecting nested forum replies

import surql from "$lib/surrealtag"

export type Replies = {
	author: {
		number: number
		username: string
	}
	content: {
		id: string
		text: string
		updated: string
	}[]
	dislikeCount: number
	dislikes: boolean
	id: string
	likeCount: number
	likes: boolean
	parentReplyId: null
	posted: string
	replies: Replies
	visibility: string
}[]

const SELECTFROM = surql`
	SELECT
		*,
		(SELECT text, updated FROM $parent.content
		ORDER BY updated DESC) AS content,
		string::split(type::string(id), ":")[1] AS id,
		NONE AS parentReplyId,
		(SELECT number, username FROM <-posted<-user)[0] AS author,
		
		count(<-likes) AS likeCount,
		count(<-dislikes) AS dislikeCount,
		($user ∈ <-likes<-user.id) AS likes,
		($user ∈ <-dislikes<-user.id) AS dislikes,

		# again #
	FROM`

export function recurse(query: (from: string) => string) {
	let rep = query(SELECTFROM)

	for (let i = 0; i < 9; i++)
		rep = rep.replace(
			/# again #/g,
			surql`(${SELECTFROM} <-replyToReply<-forumReply) AS replies`,
		)

	return rep.replace(/# again #/g, "[] AS replies")
}
