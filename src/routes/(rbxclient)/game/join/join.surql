SELECT
	(SELECT
		meta::id(id) AS id,
		serverIP,
		serverPort,
		(SELECT number FROM <-owns<-user)[0] AS ownerUser
	FROM ->place)[0] AS place,
	(SELECT username, number, permissionLevel
	FROM <-user)[0] AS user
FROM $playing;
