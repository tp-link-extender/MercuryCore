LET $render = CREATE render CONTENT {
	type: $renderType,
	status: "Pending",
	created: time::now(),
	completed: NONE, # hmm..
	relativeId: $relativeId,
};
record::id($render[0].id);
