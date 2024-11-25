// (previously) Functions for selecting nested forum replies or asset comments

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
