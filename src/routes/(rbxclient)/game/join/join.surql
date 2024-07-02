SELECT
	(SELECT
		meta::id(id) AS id,
		serverIP,
		serverPort,
		(SELECT username FROM <-owns<-user)[0] AS ownerUser
	FROM ->place)[0] AS place,
	(SELECT permissionLevel, username
	FROM <-user)[0] AS user
FROM $playing;
