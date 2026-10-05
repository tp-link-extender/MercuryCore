# grants ownership of every item inside a package (nested packages included)
# the package itself is owned via the normal buy flow; ownership of items already owned is skipped (from packageItems)

FOR $item IN $items {
	RELATE $user->ownsAsset->$item;
};
