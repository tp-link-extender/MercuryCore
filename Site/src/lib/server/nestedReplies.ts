// (previously) Functions for selecting nested forum replies or asset comments

export type Replies = {
	id: string
	author: BasicUser
	content: {
		id: string
		text: string
		updated: Date
	}[]
	created: string
	dislikes: boolean
	likes: boolean
	parentReplyId: null
	pinned: boolean
	replies: Replies
	score: number
	visibility: string
}[]
