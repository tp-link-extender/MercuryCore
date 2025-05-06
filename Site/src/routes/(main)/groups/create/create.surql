LET $group = CREATE group SET name = $name;
RELATE $user->owns->$group;
RELATE $user->member->$group SET time = time::now();
