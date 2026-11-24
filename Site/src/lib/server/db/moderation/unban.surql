UPDATE moderation SET active = false WHERE out = $moderatee;
fn::auditLog("Moderation", $note, $user);
