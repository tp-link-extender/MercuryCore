LET $s = SELECT * FROM ONLY $sess;
LET $u = (SELECT
    record::id(id) AS id,
	(SELECT text, updated FROM $parent.bio ORDER BY updated)[$] AS bio,
    bodyColours,
    # created,
    IF email THEN
		string::concat("*******@", string::split(email, "@")[$]) 
	ELSE
		""
	END AS email,
    lastOnline,
    permissionLevel,
    css,
    theme,
	status,
	username
FROM $sess<-hasSession<-user)[0];

IF $s != NONE {
	IF $s.expiresAt < time::now() {
		DELETE $s;
		$s = NULL;
	} ELSE IF $s.expiresAt + 15d < time::now() {
		$s.expiresAt = time::now() + 30d;
	};
};

{
	session: IF $s == NONE THEN
		NONE
	ELSE 
		{
			id: record::id($s.id),
			user: $u.id,
			expiresAt: $s.expiresAt,
		}
	END,
	user: $u,
};

