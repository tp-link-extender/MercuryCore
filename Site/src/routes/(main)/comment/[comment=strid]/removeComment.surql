LET $visibility = IF $moderate { "Moderated" } ELSE { "Deleted" };
LET $text = IF $moderate { "[removed]" } ELSE { "[deleted]" };
UPDATE $comment SET
	visibility = $visibility,
	content += {
		text: $text,
		updated: time::now(),
	}
WHERE IF $moderate {
	true 
} ELSE {
	<-createdComment[0]<-user[0].id = $user
} RETURN VALUE 1;
