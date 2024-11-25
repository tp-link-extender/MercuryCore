DELETE $user<-friends WHERE in = $user2;
DELETE $user->friends WHERE out = $user2;
DELETE $user->notification WHERE out = $user2
	AND type = "NewFriend"
	AND !read;
