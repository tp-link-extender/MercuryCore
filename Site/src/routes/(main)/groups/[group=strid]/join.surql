# Joining again does nothing, so repeated requests can't inflate the member count
IF $user NOT IN $group<-member<-user.id {
	RELATE $user->member->$group;
};
