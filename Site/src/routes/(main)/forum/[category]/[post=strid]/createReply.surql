LET $reply = CREATE ONLY forumReply CONTENT {
	posted: time::now(),
	visibility: "Visible",
	pinned: false,
	content: [{
		text: $content,
		updated: time::now(),
	}],
};
RELATE $reply->replyToPost->$post;
IF $replyId {
	RELATE $reply->replyToReply->$replyId;
};
RELATE $user->created->$reply;

record::id($reply.id);
