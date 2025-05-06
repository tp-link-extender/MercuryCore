LET $group = CREATE group SET name = $name;
RELATE $user->ownsGroup->$group;
RELATE $user->member->$group SET time = time::now();
