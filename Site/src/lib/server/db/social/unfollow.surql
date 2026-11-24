DELETE $user->follows WHERE out = $user2;
DELETE $user->notification WHERE out = $user2
	AND type = "Follower"
	AND !read;
