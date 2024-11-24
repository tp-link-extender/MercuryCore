# Unequip if there's already a T-Shirt/Shirt/Pants/Face equipped
IF $type {
	DELETE $user->wearing WHERE out.type = $type;
};
RELATE $user->wearing->$asset SET time = time::now();
RELATE $user->recentlyWorn->$asset SET time = time::now();
