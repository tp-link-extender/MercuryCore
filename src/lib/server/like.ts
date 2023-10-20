import { query, surql } from "./surreal"

export const like = (userId: string, thing: string) =>
	query(
		surql`
			DELETE $user->dislikes WHERE out = $thing;
			IF $user ∉ (SELECT * FROM $thing<-likes).in THEN
				RELATE $user->likes->$thing
					SET time = time::now()
			END`,
		{ thing, user: `user:${userId}` },
	)
export const unlike = (userId: string, thing: string) =>
	query(surql`DELETE $user->likes WHERE out = $thing`, {
		thing,
		user: `user:${userId}`,
	})
export const dislike = (userId: string, thing: string) =>
	query(
		surql`
			DELETE $user->likes WHERE out = $thing;
			IF $user ∉ (SELECT * FROM $thing<-dislikes).in THEN
				RELATE $user->dislikes->$thing
					SET time = time::now()
			END`,
		{ thing, user: `user:${userId}` },
	)
export const undislike = (userId: string, thing: string) =>
	query(surql`DELETE $user->dislikes WHERE out = $thing`, {
		thing,
		user: `user:${userId}`,
	})

export function likeSwitch(action: string, userId: string, thing: string) {
	switch (action) {
		case "like":
			return like(userId, thing)
		case "unlike":
			return unlike(userId, thing)
		case "dislike":
			return dislike(userId, thing)
		case "undislike":
			return undislike(userId, thing)
	}
}
