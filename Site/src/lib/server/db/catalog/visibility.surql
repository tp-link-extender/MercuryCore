UPDATE $asset SET visibility = $visibility;
UPDATE $asset->imageAsset->asset SET visibility = $visibility;
fn::auditLog("Moderation", $note, $user);
