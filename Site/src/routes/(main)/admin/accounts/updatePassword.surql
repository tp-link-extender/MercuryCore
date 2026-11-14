LET $out = UPDATE user SET hashedPassword = $npassword
	WHERE usernameLower = string::lowercase($username)
	RETURN VALUE 1;

array::len($out) == 1;