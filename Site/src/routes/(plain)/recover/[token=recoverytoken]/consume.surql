# Deleting and returning in one statement means a token can only ever be used once, even by concurrent requests
(DELETE recoveryCode WHERE hash = $hash AND expires > time::now() RETURN BEFORE)[0].user;
