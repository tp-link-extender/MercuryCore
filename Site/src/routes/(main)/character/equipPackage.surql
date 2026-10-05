# equipping a package: items inside it that are already worn are unequipped first,
# as well as anything conflicting with the package's one-per-slot items (hats included)

DELETE $user->wearing WHERE out IN $children;
DELETE $user->wearing WHERE out.type IN $conflicting;
FOR $child IN $children {
	RELATE $user->wearing->$child;
	RELATE $user->recentlyWorn->$child;
};
