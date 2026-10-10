LET $group = CREATE type::record("group", $economyId) SET name = $name;
RELATE $user->member->$group;
