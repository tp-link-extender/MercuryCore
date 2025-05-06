LET $render = CREATE render CONTENT {
	relativeId: $relativeId,
	type: $renderType,
};
record::id($render[0].id);
