import type { Scored } from "$lib/like"


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
