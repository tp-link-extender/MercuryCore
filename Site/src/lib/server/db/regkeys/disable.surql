UPDATE $regKey SET usesLeft = 0;
fn::auditLog("Administration", $msg, $user);
