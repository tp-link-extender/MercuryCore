import type { Scored } from "$lib/like2"

export interface Comment extends Scored {
	author: BasicUser
	comments: Comment[]
	content: {
		text: string
		updated: Date
	}[]
	created: Date
	id: string
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
	parentId: string
	pinned: boolean
	type: string[]
	visibility: string
}
