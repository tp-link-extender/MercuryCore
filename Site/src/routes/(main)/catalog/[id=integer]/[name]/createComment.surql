LET $comment = CREATE $assetComment CONTENT {
	posted: time::now(),
	visibility: "Visible",
	pinned: false,
	content: [{
		text: $content,
		updated: time::now(),
	}],
};
RELATE $comment->replyToAsset->$asset;
IF $commentId {
	RELATE $comment->replyToComment->$commentId;
};
RELATE $user->created->$comment;
