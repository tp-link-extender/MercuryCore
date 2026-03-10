import type { Scored } from "$lib/like2"

export interface Comment extends Scored {
	id: string
	author: BasicUser
	content: {
		text: string
		updated: Date
	}[]
	comments: Comment[]
	created: Date
	parentId: string
	pinned: boolean
	type: string[]
	visibility: string
	info?:
		| {
				type: "forum"
				category: string
				post: string
		  }
		| {
				type: "asset"
				asset: string
				slug: string
		  }
}
