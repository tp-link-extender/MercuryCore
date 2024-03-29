// Functions for selecting nested forum replies or asset comments

import { surql } from "$lib/server/surreal"

export type Replies = {
	author: {
		number: number
		status: "Playing" | "Online" | "Offline"
		username: string
	}
	content: {
		id: string
		text: string
		updated: string
	}[]
	dislikes: boolean
	id: string
	likes: boolean
	parentReplyId: null
	pinned: boolean
	posted: string
	replies: Replies
	score: number
	visibility: string
}[]

const SELECTFROM = surql`
	SELECT
		*,
		(SELECT text, updated FROM $parent.content
		ORDER BY updated DESC) AS content,
		meta::id(id) AS id,
		NONE AS parentReplyId,
		(SELECT number, status, username
		FROM <-posted<-user)[0] AS author,

		count(<-likes) - count(<-dislikes) AS score,
		$user INSIDE <-likes<-user.id AS likes,
		$user INSIDE <-dislikes<-user.id AS dislikes,

		# again #
	FROM`

export function recurse(
	query: (from: string) => string,
	relationName: string,
	commentName: string,
	times = 9 // On a comment page, the top comment is already selected
) {
	let rep = query(SELECTFROM)

	for (let i = 0; i < times; i++)
		rep = rep.replace(
			/# again #/g,
			surql`
				(${SELECTFROM} <-${relationName}<-${commentName}) AS replies`
		)

	return rep.replace(/# again #/g, "[] AS replies")
}
