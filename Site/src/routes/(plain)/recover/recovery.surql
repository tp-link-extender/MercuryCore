LET $u = (SELECT id FROM user WHERE email = $email)[0].id; # remember, email addresses ARE case-sensitive
IF $u {
	# Only one token per user can be valid at a time
	DELETE recoveryCode WHERE user = $u;
	CREATE recoveryCode SET hash = $hash, user = $u;
};
!!$u;
