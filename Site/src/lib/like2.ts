import type { RemoteForm } from "$app/server"

export interface Scored {
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

// A type alias rather than an interface: the forms on the pages infer object literal types, which only assign to LikeForm when this is one too
// oxlint-disable-next-line typescript/consistent-type-definitions
type Data = {
	action: "like" | "unlike" | "dislike" | "undislike"
	id: string
}

export type LikeForm = RemoteForm<Data, void>
export type LikeEnhance = ReturnType<LikeForm["enhance"]>
