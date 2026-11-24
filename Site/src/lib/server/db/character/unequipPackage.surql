# unequipping a package: every item inside it stops being worn

FOR $child IN $children {
	DELETE $user->wearing WHERE out = $child;
};
