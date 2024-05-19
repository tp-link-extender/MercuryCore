import { RecordId, equery, surql } from "./surreal"

type ScoreResult = {
	score: number
}[]
const countScore = surql`
	(SELECT count(<-likes) - count(<-dislikes) AS score
	FROM $thing)[0]`

type LikesResult = {
	likeCount: number
	dislikeCount: number
}[]
const countLikes = surql`
	(SELECT 
		count(SELECT 1 FROM <-likes) AS likeCount,
		count(SELECT 1 FROM <-dislikes) AS dislikeCount
	FROM $thing)[0]`

const likeQuery = surql`
	DELETE $user->dislikes WHERE out = $thing;
	IF $user NOT IN (SELECT * FROM $thing<-likes).in {
		RELATE $user->likes->$thing SET time = time::now()
	};`
const unlikeQuery = surql`DELETE $user->likes WHERE out = $thing;`
const dislikeQuery = surql`
	DELETE $user->likes WHERE out = $thing;
	IF $user NOT IN (SELECT * FROM $thing<-dislikes).in {
		RELATE $user->dislikes->$thing SET time = time::now()
	};`
const undislikeQuery = surql`DELETE $user->dislikes WHERE out = $thing;`

// most overengineered thing I have ever written
// "you won't drown in millions of little tiny functions" they said
const getParams = (userId: string, thing: RecordId<string>) => ({
	user: new RecordId("user", userId),
	thing,
})

type QueryFunction<T> = (
	userId: string,
	thing: RecordId<string>,
	queryString: string
) => Promise<T>

const queryScore: QueryFunction<number> = async (userId, thing, queryString) =>
	(
		await equery<ScoreResult>(
			queryString + countScore,
			getParams(userId, thing)
		)
	).pop()?.score || 0
const queryLikes: QueryFunction<{
	likeCount: number
	dislikeCount: number
}> = async (userId, thing, queryString) =>
	(
		await equery<LikesResult>(
			queryString + countLikes,
			getParams(userId, thing)
		)
	).pop() || {
		likeCount: 0,
		dislikeCount: 0,
	}
const queryNone: QueryFunction<void> = async (userId, thing, queryString) => {
	await equery(queryString, getParams(userId, thing))
}

// the things we do for those sweet sweet type definitions
// likeLikes returns the like and dislike count
// likeScore returns the score (likes - dislikes)
// likeNone returns nothing
export const likeLikes = async (userId: string, thing: RecordId<string>) =>
	queryLikes(userId, thing, likeQuery)
export const likeScore = async (userId: string, thing: RecordId<string>) =>
	queryScore(userId, thing, likeQuery)
export const likeNone = async (userId: string, thing: RecordId<string>) =>
	queryNone(userId, thing, likeQuery)

export const unlikeLikes = async (userId: string, thing: RecordId<string>) =>
	queryLikes(userId, thing, unlikeQuery)
export const unlikeScore = async (userId: string, thing: RecordId<string>) =>
	queryScore(userId, thing, unlikeQuery)
export const unlikeNone = async (userId: string, thing: RecordId<string>) =>
	queryNone(userId, thing, unlikeQuery)

export const dislikeLikes = async (userId: string, thing: RecordId<string>) =>
	queryLikes(userId, thing, dislikeQuery)
export const dislikeScore = async (userId: string, thing: RecordId<string>) =>
	queryScore(userId, thing, dislikeQuery)
export const dislikeNone = async (userId: string, thing: RecordId<string>) =>
	queryNone(userId, thing, dislikeQuery)

export const undislikeLikes = async (userId: string, thing: RecordId<string>) =>
	queryLikes(userId, thing, undislikeQuery)
export const undislikeScore = async (userId: string, thing: RecordId<string>) =>
	queryScore(userId, thing, undislikeQuery)
export const undislikeNone = async (userId: string, thing: RecordId<string>) =>
	queryNone(userId, thing, undislikeQuery)

// smells like legacy
export {
	likeNone as like,
	unlikeNone as unlike,
	dislikeNone as dislike,
	undislikeNone as undislike,
}

export type LikeActions = "like" | "unlike" | "dislike" | "undislike"

// better than like switch
export const likeActions = Object.freeze({
	like: likeNone,
	unlike: unlikeNone,
	dislike: dislikeNone,
	undislike: undislikeNone,
})
export const likeScoreActions = Object.freeze({
	like: likeScore,
	unlike: unlikeScore,
	dislike: dislikeScore,
	undislike: undislikeScore,
})
export const likeLikesActions = Object.freeze({
	like: likeLikes,
	unlike: unlikeLikes,
	dislike: dislikeLikes,
	undislike: undislikeLikes,
})
