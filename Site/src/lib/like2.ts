import type { RemoteForm } from "$app/server"

/** Anything that can be liked, with whichever counts it shows. */
export interface Likeable {
	dislikeCount?: number
	dislikes: boolean
	likeCount?: number
	likes: boolean
	score?: number
}

export interface Scored extends Likeable {
	score: number
}

function undislike(t: Likeable) {
	if (!t.dislikes) return
	if (t.score != null) t.score++
	if (t.dislikeCount != null) t.dislikeCount--
	t.dislikes = false
}
function unlike(t: Likeable) {
	if (!t.likes) return
	if (t.score != null) t.score--
	if (t.likeCount != null) t.likeCount--
	t.likes = false
}

export const likeFns: { [_: string]: (t: Likeable) => void } = Object.freeze({
	dislike: t => {
		if (t.dislikes) return
		unlike(t)
		if (t.score != null) t.score--
		if (t.dislikeCount != null) t.dislikeCount++
		t.dislikes = true
	},
	like: t => {
		if (t.likes) return
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
