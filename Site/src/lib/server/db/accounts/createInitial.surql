# One transaction, and stuff:initialAccount can only be created once, so two requests at the same time can't both create a level-5 account
BEGIN TRANSACTION;
IF count(SELECT 1 FROM user) > 0 {
	THROW "There's already an account registered";
};
CREATE stuff:initialAccount SET created = time::now();
LET $u = CREATE ONLY user CONTENT {
	bodyColours: $bodyColours,
	email: "",
	hashedPassword: $hashedPassword,
	permissionLevel: 5,
	username: $username,
} RETURN VALUE id;
$u;
COMMIT TRANSACTION;
