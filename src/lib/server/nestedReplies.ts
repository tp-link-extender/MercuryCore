// Functions for selecting nested forum replies or asset comments

export type Replies = {
	author: BasicUser
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

const SELECTFROM = `
	SELECT
		*,
		(SELECT text, updated FROM $parent.content
		ORDER BY updated DESC) AS content,
		meta::id(id) AS id,
		NONE AS parentReplyId,
		(SELECT number, status, username
		FROM <-posted<-user)[0] AS author,

		count(<-likes) - count(<-dislikes) AS score,
		$user IN <-likes<-user.id AS likes,
		$user IN <-dislikes<-user.id AS dislikes,

		# again #
	FROM`

const asReplies = (from: string) => `(${from}) AS replies`

/**
 * Recursively select nested replies or comments in a database query.
 * @param query
 * @param relationName
 * @param commentName
 * @param times
 * @returns
 */
export function recurse(query: string, query2 = query) {
	let rep = asReplies(`${SELECTFROM} ${query}`) 
	const q = asReplies(`${SELECTFROM} ${query2}`) 
	// On a comment page, the top comment is already selected
	for (let i = 0; i < 9; i++) rep = rep.replace("# again #", q)

	return rep.replace("# again #", "[] AS replies")
}
