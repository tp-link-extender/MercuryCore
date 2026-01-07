import type { SubmitFunction } from "@sveltejs/kit"

export type Scored = {
	dislikeCount?: number
	dislikes: boolean
	likeCount?: number
	likes: boolean
	score?: number
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

const fns: { [_: string]: (t: Scored) => void } = Object.freeze({
	dislike: t => {
		if (t.score != null) t.score--
		if (t.dislikeCount != null) t.dislikeCount++
		unlike(t)
		t.dislikes = true
	},
	like: t => {
		if (t.score != null) t.score++
		if (t.likeCount != null) t.likeCount++
		undislike(t)
		t.likes = true
	},
	undislike,
	unlike,
})

// set allows for reactivity (no, renaming to like.svelte.ts doesn't work)
export const likeEnhance =
	(t: Scored): SubmitFunction =>
	({ formData }) => {
		fns[formData.get("action")?.toString() || ""](t)
		return () => {} // yes, very necessary
	}
