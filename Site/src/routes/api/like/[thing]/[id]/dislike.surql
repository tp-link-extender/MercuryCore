IF $user NOT IN $thing<-dislikes<-user {
	RELATE $user->dislikes->$thing;
};
