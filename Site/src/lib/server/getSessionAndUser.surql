LET $s = SELECT record::id(id) AS id, expiresAt FROM ONLY $sess;
LET $u = (SELECT
    record::id(id) AS id,
	(SELECT text, updated FROM $parent.bio ORDER BY updated)[$] AS bio,
    bodyColours,
    # created,
    IF email {
		string::concat("*******@", string::split(email, "@")[$]) 
	} ELSE {
		""
	} AS email,
    lastOnline,
    permissionLevel,
    css,
    theme,
	status,
	username
FROM $sess<-hasSession<-user)[0];

IF $s {
	IF $s.expiresAt < time::now() {
		DELETE $s;
		$s = NONE;
	} ELSE IF $s.expiresAt + 15d < time::now() {
		$s.expiresAt = time::now() + 30d;
	};
};

{
	session: $s,
	user: $u,
};

