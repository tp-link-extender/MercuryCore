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

# Only what every request needs: the hooks read the theme and CSS, and the layout shows the rest.
# Anything else a page needs is loaded by that page.
LET $u = (SELECT
	record::id(id) AS id,
	css,
	permissionLevel,
	status,
	theme,
	username
FROM $sess<-hasSession<-user WHERE $s)[0];

{
	session: IF $s { record::id($s.id) } ELSE { NONE },
	user: $u,
};
