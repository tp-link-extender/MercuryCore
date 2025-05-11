import type { Scored } from "$lib/like"

export const commentType = (type: string[], id: string) => {
	const mtype = type[0]
	if (
		(mtype === "status" && type.length === 1) || // status update
		(mtype === "forum" && type.length === 2) || // forum post
		(mtype === "asset" && type.length === 2) // asset comment
	)
		return [...type, id]

	// status update comment
	// forum post comment comment
	// asset comment comment
	return type
}

export interface Comment extends Scored {
	id: string
	author: BasicUser
	content: {
		text: string
		updated: Date
	}[]
	comments: []
	created: Date
	parentId: string
	pinned: boolean
	type: string[]
	visibility: string
	info: {
		category?: string
		post?: string
	}
}
