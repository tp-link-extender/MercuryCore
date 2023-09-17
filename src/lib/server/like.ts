import surql from "$lib/surrealtag"
import { squery } from "$lib/server/surreal"
import { error } from "@sveltejs/kit"

export const like = (userId: string, thing: string, thingId: string) =>
		squery(surql`
			DELETE user:${userId}->dislikes WHERE out=${thing}:${thingId};
			IF user:${userId} ∉ (SELECT * FROM ${thing}:${thingId}<-likes).in THEN
				RELATE user:${userId}->likes->${thing}:${thingId}
					SET time = time::now()
			END`),
	unlike = (userId: string, thing: string, thingId: string) =>
		squery(
			surql`DELETE user:${userId}->likes WHERE out=${thing}:${thingId}`,
		),
	dislike = (userId: string, thing: string, thingId: string) =>
		squery(surql`
			DELETE user:${userId}->likes WHERE out=${thing}:${thingId};
			IF user:${userId} ∉ (SELECT * FROM ${thing}:${thingId}<-dislikes).in THEN
				RELATE user:${userId}->dislikes->${thing}:${thingId}
					SET time = time::now()
			END`),
	undislike = (userId: string, thing: string, thingId: string) =>
		squery(
			surql`DELETE user:${userId}->dislikes WHERE out=${thing}:${thingId}`,
		)

export async function likeSwitch(
	action: string,
	userId: string,
	thing: string,
	thingId: string,
) {
	try {
		switch (action) {
			case "like":
				await like(userId, thing, thingId)
				break
			case "unlike":
				await unlike(userId, thing, thingId)
				break
			case "dislike":
				await dislike(userId, thing, thingId)
				break
			case "undislike":
				await undislike(userId, thing, thingId)
		}
	} catch (e) {
		console.error(e)
		throw error(500, "Redis error 2")
	}
}
