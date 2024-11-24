LET $s = CREATE $sess SET expiresAt = time::unix($expiresAt);
RELATE $user->hasSession->$s;
