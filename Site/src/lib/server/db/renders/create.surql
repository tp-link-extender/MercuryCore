LET $render = CREATE ONLY render CONTENT {
	relativeId: $relativeId,
	type: $renderType,
};
record::id($render.id);
