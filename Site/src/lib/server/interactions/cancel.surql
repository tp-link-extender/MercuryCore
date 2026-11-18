DELETE $user->request WHERE out = $user2;
DELETE $user->notification WHERE out = $user2
	AND type = "FriendRequest"
	AND !read;
