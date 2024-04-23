import { mquery, surql } from "./surreal"

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
type QueryFunction<T> = (
	params: { thing: string; user: string },
	queryString: string
) => Promise<T>

const queryScore: QueryFunction<number> = async (params, queryString) =>
	(await mquery<ScoreResult>(queryString + countScore, params)).pop()
		?.score || 0
const queryLikes: QueryFunction<{
	likeCount: number
	dislikeCount: number
}> = async (params, queryString) =>
	(await mquery<LikesResult>(queryString + countLikes, params)).pop() || {
		likeCount: 0,
		dislikeCount: 0,
	}
const queryNone: QueryFunction<void> = async (params, queryString) => {
	await mquery(queryString, params)
}

// the things we do for those sweet sweet type definitions
// likeLikes returns the like and dislike count
// likeScore returns the score (likes - dislikes)
// likeNone returns nothing
export const likeLikes = async (userId: string, thing: string) =>
	queryLikes({ thing, user: `user:${userId}` }, likeQuery)
export const likeScore = async (userId: string, thing: string) =>
	queryScore({ thing, user: `user:${userId}` }, likeQuery)
export const likeNone = async (userId: string, thing: string) =>
	queryNone({ thing, user: `user:${userId}` }, likeQuery)

export const unlikeLikes = async (userId: string, thing: string) =>
	queryLikes({ thing, user: `user:${userId}` }, unlikeQuery)
export const unlikeScore = async (userId: string, thing: string) =>
	queryScore({ thing, user: `user:${userId}` }, unlikeQuery)
export const unlikeNone = async (userId: string, thing: string) =>
	queryNone({ thing, user: `user:${userId}` }, unlikeQuery)

export const dislikeLikes = async (userId: string, thing: string) =>
	queryLikes({ thing, user: `user:${userId}` }, dislikeQuery)
export const dislikeScore = async (userId: string, thing: string) =>
	queryScore({ thing, user: `user:${userId}` }, dislikeQuery)
export const dislikeNone = async (userId: string, thing: string) =>
	queryNone({ thing, user: `user:${userId}` }, dislikeQuery)

export const undislikeLikes = async (userId: string, thing: string) =>
	queryLikes({ thing, user: `user:${userId}` }, undislikeQuery)
export const undislikeScore = async (userId: string, thing: string) =>
	queryScore({ thing, user: `user:${userId}` }, undislikeQuery)
export const undislikeNone = async (userId: string, thing: string) =>
	queryNone({ thing, user: `user:${userId}` }, undislikeQuery)

// smells like legacy
export {
	likeNone as like,
	unlikeNone as unlike,
	dislikeNone as dislike,
	undislikeNone as undislike,
}

export type LikeActions = "like" | "unlike" | "dislike" | "undislike"

// better than like switch
export const likeActions = {
	like: likeNone,
	unlike: unlikeNone,
	dislike: dislikeNone,
	undislike: undislikeNone,
}
export const likeScoreActions = {
	like: likeScore,
	unlike: unlikeScore,
	dislike: dislikeScore,
	undislike: undislikeScore,
}
export const likeLikesActions = {
	like: likeLikes,
	unlike: unlikeLikes,
	dislike: dislikeLikes,
	undislike: undislikeLikes,
}
