import { mquery, surql } from "./surreal"

type Result = {
	score: number
}[]

const countScore = surql`
	(SELECT count(<-likes<-user) - count(<-dislikes<-user) AS score
	FROM $thing)[0]`

export const like = async (userId: string, thing: string) => {
	const result = await mquery<Result>(
		surql`
			DELETE $user->dislikes WHERE out = $thing;
			IF $user NOTINSIDE (SELECT * FROM $thing<-likes).in {
				RELATE $user->likes->$thing SET time = time::now()
			};
			${countScore}`,
		{ thing, user: `user:${userId}` }
	)
	return result.pop()?.score || 0
}
export const unlike = async (userId: string, thing: string) => {
	const result = await mquery<Result>(
		surql`
			DELETE $user->likes WHERE out = $thing;
			${countScore}`,
		{ thing, user: `user:${userId}` }
	)
	return result.pop()?.score || 0
}
export const dislike = async (userId: string, thing: string) => {
	const result = await mquery<Result>(
		surql`
			DELETE $user->likes WHERE out = $thing;
			IF $user NOTINSIDE (SELECT * FROM $thing<-dislikes).in {
				RELATE $user->dislikes->$thing SET time = time::now()
			};
			${countScore}`,
		{ thing, user: `user:${userId}` }
	)
	return result.pop()?.score || 0
}
export const undislike = async (userId: string, thing: string) => {
	const result = await mquery<Result>(
		surql`
			DELETE $user->dislikes WHERE out = $thing;
			${countScore}`,
		{ thing, user: `user:${userId}` }
	)
	return result.pop()?.score || 0
}
// better than like switch
export const likeActions = {
	like,
	unlike,
	dislike,
	undislike,
}
