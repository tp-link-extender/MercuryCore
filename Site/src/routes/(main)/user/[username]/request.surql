RELATE $user->request->$user2 SET time = time::now();
fn::notify($user, $user2, "FriendRequest", $note, $relativeId);
