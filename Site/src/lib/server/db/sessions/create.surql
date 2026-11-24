LET $s = CREATE ONLY session;
record::id($s.id);

RELATE $user->hasSession->$s;
