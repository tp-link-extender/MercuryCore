LET $out = UPDATE user SET hashedPassword = $npassword
	WHERE $username.lowercase() = username.lowercase()
	RETURN VALUE 1;

array::len($out) == 1;