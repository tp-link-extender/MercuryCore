LET $u = (SELECT id FROM user WHERE email = $email)[0].id; # remember, email addresses ARE case-sensitive
$u;
IF $u {
	RETURN CREATE ONLY recoveryCode SET user = $u RETURN VALUE code;
};
