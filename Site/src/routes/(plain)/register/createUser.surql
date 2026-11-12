LET $keyUpdate = IF $key {
	UPDATE $key SET usesLeft -= 1
	WHERE usesLeft > 0 AND (expiry IS NONE OR expiry > time::now())
	RETURN AFTER
} ELSE {
	[true]
};

LET $u = IF $key AND array::len($keyUpdate) = 0 {
	NONE
} ELSE {
	CREATE ONLY user CONTENT {
		bodyColours: $bodyColours,
		email: $email,
		hashedPassword: $hashedPassword,
		permissionLevel: $permissionLevel,
		username: $username,
	} RETURN VALUE id
};

IF $u AND $key {
	RELATE $u->used->$key;
};

$u;
