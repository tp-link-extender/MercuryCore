import type { SubmitFunction } from "@sveltejs/kit"

export type Scored = {
	likes: boolean
	dislikes: boolean
	score: number
}

export const likeEnhance =
	(t: Scored): SubmitFunction =>
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
				break
		}

		return () => {}
	}
