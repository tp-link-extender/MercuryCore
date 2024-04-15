LET $application = (
	SELECT * FROM application WHERE discordId = $id
	ORDER BY created DESC LIMIT 1
)[0];
IF !$application {
	THROW "Application not found"
} ELSE IF $application.status != "Pending" {
	THROW "Application already reviewed"
};
BEGIN TRANSACTION;
UPDATE $application MERGE {
	status: $status,
	reason: $reason,
	reviewed: time::now()
};
# If the response was accepted, create a new regKey to allow the user to register
IF $status = "Accepted" {
	LET $key = (CREATE regKey CONTENT {
		usesLeft: 1,
		expiry: NONE,
		created: time::now(),
	})[0];
	RELATE $application->applicationKey->$key;
	RETURN $key
};
COMMIT TRANSACTION;
