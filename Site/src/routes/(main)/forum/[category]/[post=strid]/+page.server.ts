import { idRegex } from "$lib/paramTests";
import exclude from "$lib/server/exclude";
import filter from "$lib/server/filter";
import formError from "$lib/server/formError";
import { like } from "$lib/server/like";
import { authorise } from "$lib/server/lucia";
import type { Replies } from "$lib/server/nestedReplies";
import ratelimit from "$lib/server/ratelimit";
import { Record, type RecordId, db } from "$lib/server/surreal";
import { error } from "@sveltejs/kit";
import { zod } from "sveltekit-superforms/adapters";
import { superValidate } from "sveltekit-superforms/server";
import { z } from "zod";
import { actions as categoryActions } from "../+page.server";
import type { RequestEvent } from "./$types.d.ts";
import createReplyQuery from "./createReply.surql";
import postQuery from "./post.surql";
import updateVisibilityQuery from "./updateVisibility.surql";

const schema = z.object({
	content: z.string().min(1).max(1000),
	replyId: z.string().optional(),
});

type ForumPost = {
	author: BasicUser;
	categoryName: string;
	content: {
		text: string;
		updated: string;
	}[];
	dislikes: boolean;
	id: string;
	likes: boolean;
	pinned: boolean;
	posted: string;
	replies: Replies;
	score: number;
	title: string;
	visibility: string;
};

export async function load({ locals, params }) {
	exclude("Forum");
	const { user } = await authorise(locals);

	const [[post]] = await db.query<ForumPost[][]>(postQuery, {
		forumPost: Record("forumPost", params.post),
		user: Record("user", user.id),
	});
	if (!post) error(404, "Not found");

	return {
		form: await superValidate(zod(schema)),
		post,
	};
}

async function findReply<T>(
	e: RequestEvent,
	permissionLevel?: number,
	input = "SELECT 1 FROM $forumReply",
) {
	const { user } = await authorise(e.locals, permissionLevel);

	const id = e.url.searchParams.get("id");
	if (!id) error(400, "Missing reply id");
	// Incorrect ids filtering is done with route matchers now

	const [[reply]] = await db.query<T[][]>(input, {
		forumReply: Record("forumReply", id),
	});
	if (!reply) error(404, "Reply not found");

	return { user, reply, id };
}

const updateVisibility = (visibility: string, text: string, id: string) =>
	db.query(updateVisibilityQuery, {
		forumReply: Record("forumReply", id),
		text,
		visibility,
	});

const pinThing = (pinned: boolean, thing: RecordId<string>) =>
	db.query("UPDATE $thing SET pinned = $pinned", { thing, pinned });

// wrapping this stuff in arrow functions just to prevent it from maybe returning god knows what to the client from an action
const pinReply = (pinned: boolean) => async (e: RequestEvent) => {
	exclude("Forum");
	await pinThing(pinned, Record("forumReply", (await findReply(e, 4)).id));
};

const pinPost = (pinned: boolean) => async (e: RequestEvent) => {
	await authorise(e.locals, 4);

	const id = e.url.searchParams.get("id");
	if (!id) error(400, "Missing post id");
	if (!idRegex.test(id)) error(400, "Invalid post id");

	await pinThing(pinned, Record("forumPost", id));
};

export const actions: import("./$types").Actions = {};
actions.reply = async ({ url, request, locals, params, getClientAddress }) => {
	exclude("Forum");
	const { user } = await authorise(locals);
	const form = await superValidate(request, zod(schema));
	if (!form.valid) return formError(form);

	// If there is a replyId, it is a reply to another reply
	const replyId = url.searchParams.get("rid");
	if (replyId && !idRegex.test(replyId)) error(400, "Invalid reply id");

	const unfiltered = form.data.content.trim();
	if (!unfiltered)
		return formError(form, ["content"], ["Reply cannot be empty"]);

	const limit = ratelimit(form, "forumReply", getClientAddress, 5);
	if (limit) return limit;

	const replypostId = replyId
		? Record("forumReply", replyId)
		: Record("forumPost", params.post);
	const [[replypost]] = await db.query<{ authorId: string }[][]>(
		`
			SELECT record::id(<-created[0]<-user[0].id) AS authorId
			FROM $replypostId  WHERE visibility = "Visible"`,
		{ replypostId },
	);
	if (!replypost) error(404, `${replyId ? "Reply" : "Post"} not found`);

	const newReply = await db.query<string[]>(createReplyQuery, {
		content: filter(unfiltered),
		user: Record("user", user.id),
		post: Record("forumPost", params.post),
		replyId: replyId ? Record("forumReply", replyId) : undefined,
	});
	const newReplyId = newReply[4];

	if (user.id !== replypost.authorId)
		await db.query(
			"fn::notify($sender, $receiver, $type, $note, $relativeId)",
			{
				sender: Record("user", user.id),
				receiver: Record("user", replypost.authorId),
				type: replyId ? "ForumReplyReply" : "ForumPostReply",
				note: `${user.username} replied to your ${
					replyId ? "reply" : "post"
				}: ${unfiltered}`,
				relativeId: newReplyId,
			},
		);

	await like(user.id, Record("forumReply", newReplyId));
};
actions.delete = async (e) => {
	exclude("Forum");
	const { user, reply, id } = await findReply<{
		authorId: string;
		visibility: string;
	}>(
		e,
		undefined,
		`
			SELECT
				record::id((<-created<-user.id)[0]) AS authorId,
				visibility
			FROM $forumReply`,
	);

	if (reply.authorId !== user.id)
		error(403, "You cannot delete someone else's reply");

	if (reply.visibility !== "Visible") error(400, "Reply already deleted");

	await updateVisibility("Deleted", "[deleted]", id);
};
actions.moderate = async (e) => {
	exclude("Forum");
	await updateVisibility("Moderated", "[removed]", (await findReply(e, 4)).id);
};
actions.pin = pinReply(true);
actions.unpin = pinReply(false);
actions.pinpost = pinPost(true);
actions.unpinpost = pinPost(false);
actions.like = (e) =>
	categoryActions.like(e as unknown as import("../$types").RequestEvent);
