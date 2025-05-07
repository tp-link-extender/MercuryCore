LET $c = CREATE ONLY comment CONTENT {
	content: [{
		text: $content,
		updated: time::now(),
	}],
	type: ["forum", $category],
};
RELATE $user->createdComment->$c;
RELATE $user->likes->$c;

record::id($c.id);
