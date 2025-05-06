LET $status = CREATE statusPost SET content = [{
	text: $content,
	updated: time::now(),
}];

RELATE $user->created->$status;
