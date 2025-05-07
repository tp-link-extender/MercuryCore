LET $c = CREATE ONLY comment CONTENT {
	content: [{
		text: $content,
		updated: time::now(),
	}],
	type: $type,
};
RELATE $user->createdComment->$c;
RELATE $user->likes->$c;
IF $comment {
	RELATE $c->commentLink->$comment;
};

record::id($c.id);
