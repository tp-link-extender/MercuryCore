BEGIN TRANSACTION;
LET $poster = (SELECT <-posted<-user AS poster FROM $forumReply)[0].poster;

UPDATE $forumReply SET content += {
	text: $text,
	updated: time::now(),
};
UPDATE $forumReply SET visibility = $visibility;
COMMIT TRANSACTION;
