import surql from "$lib/surrealtag"
import { query } from "$lib/server/surreal"

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

export async function likeSwitch(
	action: string,
	userId: string,
	thing: string,
) {
	switch (action) {
		case "like":
			await like(userId, thing)
			break
		case "unlike":
			await unlike(userId, thing)
			break
		case "dislike":
			await dislike(userId, thing)
			break
		case "undislike":
			await undislike(userId, thing)
	}
}
