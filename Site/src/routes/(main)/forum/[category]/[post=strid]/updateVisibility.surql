UPDATE $forumReply SET content += {
	text: $text,
	updated: time::now(),
};

UPDATE $forumReply SET visibility = $visibility;
