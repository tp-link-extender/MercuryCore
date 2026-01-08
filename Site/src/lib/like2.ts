import type { RemoteForm, SubmitFunction } from "@sveltejs/kit"
import { invalidateAll } from "$app/navigation"

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

export const likeFns: { [_: string]: (t: Scored) => void } = Object.freeze({
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

type Data = {
	id: string
	action: "like" | "unlike" | "dislike" | "undislike"
}

export type LikeForm = RemoteForm<Data, void>
export type LikeEnhance = ReturnType<LikeForm["enhance"]>

// reactivity actually works now, huh
// also TypeScript moment here

export const likeEnhance: (t: Scored) => Parameters<LikeForm["enhance"]>[0] =
	t => {
		console.log("START")
		return async ({ data, submit }) => {
			console.log(t)
			likeFns[data.action](t)
			console.log(t)

			await submit()
		}
	}
