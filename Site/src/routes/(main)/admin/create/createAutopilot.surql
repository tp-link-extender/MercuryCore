BEGIN;

LET $user = SELECT VALUE id FROM ONLY user WHERE email == ""; # LOLL
FOR $assetId IN $assets {
	# All the assets are cached already
	LET $cached = (SELECT * FROM assetCache:[$assetId, 1])[0]; # version 1 is usually the only version
	LET $asset = CREATE ONLY asset CONTENT {
		name: $cached.name,
		type: $cached.type,
		price: 0,
		description: [{
			text: $cached.description,
			updated: time::now(),
		}],
		visibility: "Visible",
	} RETURN VALUE id;
	RELATE $user->ownsAsset->$asset;
	RELATE $user->created->$asset;
	RELATE $cached->createdAsset->$asset;
};
# Now time for the big one
LET $cached = SELECT data, type FROM ONLY assetCache:[$assetId, $version];
LET $asset = CREATE ONLY asset CONTENT {
	name: $name,
	type: $cached.type,
	price: $price,
	description: [{
		text: $description,
		updated: time::now(),
	}],
	visibility: "Visible",
} RETURN VALUE id;
RELATE $user->ownsAsset->$asset;
RELATE $user->created->$asset;
{
	id: record::id($asset),
	type: $cached.type,
};

# TODO: check if this necessary
(SELECT
	(SELECT VALUE record::id(id)
	FROM ->createdAsset->asset)[0] AS id,
	type,
	record::id(id)[0] AS sharedId
FROM assetCache WHERE ->createdAsset->asset);

COMMIT;
