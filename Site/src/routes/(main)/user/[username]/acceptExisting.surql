DELETE $user2->request WHERE out = $user;
RELATE $user2->friends->$user SET time = time::now();
fn::notify($user, $user2, "NewFriend", $note, $relativeId);
