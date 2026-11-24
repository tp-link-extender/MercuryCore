# Unequip if there's already a T-Shirt/Shirt/Pants/Face equipped.
# Also drop any existing edge for this asset, so equipping it twice can't duplicate the relation
IF $type {
	DELETE $user->wearing WHERE out.type = $type;
};
DELETE $user->wearing WHERE out = $asset;
RELATE $user->wearing->$asset;
RELATE $user->recentlyWorn->$asset;
