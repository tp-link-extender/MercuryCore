LET $group = CREATE group CONTENT {
	name: $name,
	created: time::now(),
};
RELATE $user->owns->$group SET time = time::now();
RELATE $user->member->$group SET time = time::now();
