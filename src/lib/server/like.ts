import surql from "$lib/surrealtag"
import { squery } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"

export const like = (userId: string, thing: string) =>
		squery(
			surql`
				DELETE $user->dislikes WHERE out = $thing;
				IF $user ∉ (SELECT * FROM $thing<-likes).in THEN
					RELATE $user->likes->$thing
						SET time = time::now()
				END`,
			{ thing, user: `user:${userId}` },
		),
	unlike = (userId: string, thing: string) =>
		squery(surql`DELETE $user->likes WHERE out = $thing`, {
			thing,
			user: `user:${userId}`,
		}),
	dislike = (userId: string, thing: string) =>
		squery(
			surql`
				DELETE $user->likes WHERE out = $thing;
				IF $user ∉ (SELECT * FROM $thing<-dislikes).in THEN
					RELATE $user->dislikes->$thing
						SET time = time::now()
				END`,
			{ thing, user: `user:${userId}` },
		),
	undislike = (userId: string, thing: string) =>
		squery(surql`DELETE $user->dislikes WHERE out = $thing`, {
			thing,
			user: `user:${userId}`,
		})

export async function likeSwitch(
	action: string,
	userId: string,
	thing: string,
) {
	try {
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
	} catch (e) {
		console.error(e)
		throw error(500, "Redis error 2")
	}
}
