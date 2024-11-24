DELETE $asset;
DELETE $imageAsset;
fn::auditLog("Moderation", $note, $user);
