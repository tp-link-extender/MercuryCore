BEGIN TRANSACTION;
LET $poster = (SELECT <-posted<-user AS poster FROM $forumReply)[0].poster;

UPDATE $assetComment SET content += {
	text: $text,
	updated: time::now(),
};
UPDATE $assetComment SET visibility = $visibility;
COMMIT TRANSACTION;
