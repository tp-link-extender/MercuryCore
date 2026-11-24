# Claiming the ticket is a single statement, so it can only be used once, even by concurrent requests
LET $claimed = UPDATE $playing SET valid = false
	WHERE valid AND created > time::now() - 5m
	RETURN VALUE id;

IF array::len($claimed) > 0 {
	SELECT
		(
			SELECT
				record::id(id) AS id,
				dedicated,
				serverAddress,
				serverPort
			FROM $parent->place
		)[0] AS place,
		(
			SELECT
				permissionLevel,
				username
			FROM $parent<-user
		)[0] AS user
	FROM ONLY $playing
};
