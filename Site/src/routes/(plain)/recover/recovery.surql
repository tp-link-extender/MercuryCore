LET $u = (SELECT id FROM user WHERE emailLower = string::lowercase(string::trim($email)))[0].id; # email addresses match case-insensitively, like registration
IF $u {
	# Only one token per user can be valid at a time
	DELETE recoveryCode WHERE user = $u;
	CREATE recoveryCode SET hash = $hash, user = $u;
};
!!$u;
