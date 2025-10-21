LET $code = SELECT user, id FROM ONLY recoveryCode WHERE code = $code
	AND expires > time::now()
	AND !used;

IF $code {
	UPDATE recoveryCode SET used = true WHERE user = $code.user;
	RETURN $code.user;
};
