LET $group = CREATE group SET name = $name;
RELATE $user->member->$group;
