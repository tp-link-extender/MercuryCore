import type { Comment } from "#lib/comment.ts"
import { dbQuery } from "#lib/server/db/query.ts"
import { Record, type RecordId } from "#lib/server/surreal.ts"
import createQuery from "./comments/create.surql"
import pinQuery from "./comments/pin.surql"
import removeQuery from "./comments/remove.surql"
import replyTargetQuery from "./comments/replyTarget.surql"
import treeQuery from "./comments/tree.surql"

/** Where a comment is posted: its asset, forum category or post, or the comment it replies to. */
export type CommentType = (number | string)[]

/**
 * Finds a comment's creator and type, which a reply needs.
 * @returns Them, or undefined if the comment doesn't exist or is hidden.
 */
export async function replyTargetOf(
	id: string
): Promise<{ creatorId: string; type: string[] } | undefined> {
	const [target] = await dbQuery<{ creatorId: string; type: string[] }[]>(
		replyTargetQuery,
		{ comment: Record("comment", id) }
	)
	return target
}

/**
 * Creates a comment by a user, and returns its id.
 * @param comment The comment this one replies to, if any.
 */
export async function createComment({
	comment,
	content,
	type,
	user,
}: {
	comment?: RecordId<"comment">
	content: string
	type: CommentType
	user: RecordId<"user">
}): Promise<string> {
	const [, id] = await dbQuery<string[]>(createQuery, {
		comment,
		content,
		type,
		user,
	})
	if (!id) throw new Error("Failed to create comment record")
	return id
}

/**
 * Finds a comment and its replies, nested, as the viewer sees them.
 * @returns The comment, or undefined if there is no such comment.
 */
export async function commentTree(
	id: string,
	viewer: RecordId<"user">
): Promise<Comment | undefined> {
	const [[comment]] = await dbQuery<Comment[][]>(treeQuery, {
		comment: Record("comment", id),
		user: viewer,
	})
	return comment
}

/**
 * Sets whether a comment is pinned.
 * @returns Whether the comment exists to pin.
 */
export async function setPinned(id: string, pinned: boolean): Promise<boolean> {
	const [[ok]] = await dbQuery<1[][]>(pinQuery, {
		comment: Record("comment", id),
		pinned,
	})
	return ok === 1
}

/**
 * Removes a comment, which is marked as deleted by its author or moderated.
 * @returns Whether a comment was removed, which is false if it was already gone.
 */
export async function removeComment(
	id: string,
	user: RecordId<"user">,
	moderate: boolean
): Promise<boolean> {
	const deleted = await dbQuery<1[][]>(removeQuery, {
		comment: Record("comment", id),
		moderate,
		user,
	})
	return Boolean(deleted[2]?.[0])
}
