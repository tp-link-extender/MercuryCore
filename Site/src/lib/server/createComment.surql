LET $c = CREATE ONLY comment CONTENT {
	content: [{
		text: $content,
		updated: time::now(),
	}],
	type: $type,
};
record::id($c.id);
RELATE $user->createdComment->$c;
RELATE $user->likes->$c;
IF $comment {
	RELATE $c->commentLink->$comment;
};

