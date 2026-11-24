SELECT
	fn::currentContent(description) AS description,
	IF email {
		string::concat("*******@", parse::email::host(email))
	} ELSE {
		""
	} AS email
FROM ONLY $user;
