IF $user NOT IN $thing<-likes<-user {
	RELATE $user->likes->$thing;
};
