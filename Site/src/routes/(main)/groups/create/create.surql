LET $group = CREATE group CONTENT {
	name: $name,
	created: time::now(),
};
RELATE $user->owns->$group;
RELATE $user->member->$group SET time = time::now();
