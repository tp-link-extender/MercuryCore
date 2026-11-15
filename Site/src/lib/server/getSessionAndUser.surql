LET $now = time::now();
LET $s = SELECT id, expires FROM ONLY $sess;

# An expired session is deleted and treated as missing, so it can't be used for one more request
IF $s AND $s.expires < $now {
	DELETE $sess;
};
LET $s = IF $s AND $s.expires >= $now { $s } ELSE { NONE };

# Sessions in use are extended in the database once less than 15 days are left, as the cookie's maxAge is renewed on every request
IF $s AND $s.expires < $now + 15d {
	UPDATE $sess SET expires = $now + 30d;
};

LET $u = (SELECT
    record::id(id) AS id,
	fn::currentContent($this.description) AS description,
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
FROM $sess<-hasSession<-user WHERE $s)[0];

{
	session: IF $s { record::id($s.id) } ELSE { NONE },
	user: $u,
};
