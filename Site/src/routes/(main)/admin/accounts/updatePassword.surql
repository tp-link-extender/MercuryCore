LET $out = UPDATE user SET hashedPassword = $npassword
	WHERE usernameLower = string::lowercase($username)
	RETURN VALUE id;

# Log the user out everywhere, in case whoever had the old password still has a session
FOR $u IN $out {
	DELETE session WHERE $u IN <-hasSession<-user;
};

array::len($out) == 1;
