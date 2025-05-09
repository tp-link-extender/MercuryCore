import type { SubmitFunction } from "@sveltejs/kit"

export type Scored = {
	likes: boolean
	dislikes: boolean
	score: number
}

// set allows for reactivity (no, renaming to like.svelte.ts doesn't work)
export const likeEnhance =
	<T extends Scored>(t: T, set: (t: T) => void): SubmitFunction =>
	({ formData }) => {
		switch (formData.get("action")) {
			case "like":
				t.score++
				t.likes = true
			case "undislike":
				if (t.dislikes) t.score++
				t.dislikes = false
				break
			case "dislike":
				t.score--
				t.dislikes = true
			case "unlike":
				if (t.likes) t.score--
				t.likes = false
		}

		set(t)
		return () => {}
	}
