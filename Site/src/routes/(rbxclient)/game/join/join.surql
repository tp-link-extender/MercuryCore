SELECT
	(SELECT
		record::id(id) AS id,
		dedicated,
		serverAddress,
		serverPort,
		(SELECT username FROM <-ownsPlace<-user)[0] AS ownerUser
	FROM ->place)[0] AS place,
	(SELECT permissionLevel, username
	FROM <-user)[0] AS user
FROM ONLY $playing;

UPDATE $playing SET valid = false;
