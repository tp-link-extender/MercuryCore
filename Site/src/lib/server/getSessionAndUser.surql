LET $s = SELECT id, expires FROM ONLY $sess;
LET $u = (SELECT
    record::id(id) AS id,
	(SELECT text, updated FROM $parent.description ORDER BY updated)[$] AS description,
    bodyColours,
    # created,
    IF email {
		string::concat("*******@", parse::email::host(email)) 
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
	IF $s.expires < time::now() {
		DELETE $s;
	} ELSE IF $s.expires + 15d < time::now() {
		$s.expires = time::now() + 30d;
	};
};

{
	session: IF $s { record::id($s.id) } ELSE { NONE },
	user: $u,
};

