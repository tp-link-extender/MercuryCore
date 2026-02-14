import type { RemoteForm } from "@sveltejs/kit"

export type Scored = {
	dislikeCount?: number
	dislikes: boolean
	likeCount?: number
	likes: boolean
	score: number
}

function undislike(t: Scored) {
	if (!t.dislikes) return
	if (t.score != null) t.score++
	if (t.dislikeCount != null) t.dislikeCount--
	t.dislikes = false
}
function unlike(t: Scored) {
	if (!t.likes) return
	if (t.score != null) t.score--
	if (t.likeCount != null) t.likeCount--
	t.likes = false
}

export const likeFns: { [_: string]: (t: Scored) => void } = Object.freeze({
	dislike: t => {
		unlike(t)
		if (t.score != null) t.score--
		if (t.dislikeCount != null) t.dislikeCount++
		t.dislikes = true
	},
	like: t => {
		undislike(t)
		if (t.score != null) t.score++
		if (t.likeCount != null) t.likeCount++
		t.likes = true
	},
	undislike,
	unlike,
})

type Data = {
	id: string
	action: "like" | "unlike" | "dislike" | "undislike"
}

export type LikeForm = RemoteForm<Data, void>
export type LikeEnhance = ReturnType<LikeForm["enhance"]>
