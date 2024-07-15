LET $reply = CREATE $forumReply CONTENT {
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
RELATE $user->posted->$reply;
