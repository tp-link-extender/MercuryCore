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

export function recurse(
	query: (from: string) => string,
	relationName: string,
	commentName: string,
	times = 9 // On a comment page, the top comment is already selected
) {
	let rep = query(SELECTFROM)

	for (let i = 0; i < times; i++)
		rep = rep.replace(
			"# again #",
			`(${SELECTFROM} <-${relationName}<-${commentName}) AS replies`
		)

	return rep.replace("# again #", "[] AS replies")
}
