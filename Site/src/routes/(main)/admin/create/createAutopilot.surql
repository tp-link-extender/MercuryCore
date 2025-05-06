BEGIN TRANSACTION;
LET $user = (SELECT id FROM user WHERE number = 1)[0].id;
FOR $assetId IN $assets {
	# All the assets are cached already
	LET $id = (UPDATE ONLY stuff:increment SET asset += 1).asset;
	LET $cached = (SELECT * FROM assetCache:[$assetId, 1])[0]; # version 1 is usually the only version
	LET $asset = CREATE asset CONTENT {
		id: $id,
		name: $cached.name,
		type: $cached.type,
		price: 0,
		description: [{
			text: $cached.description,
			updated: time::now(),
		}],
		visibility: "Visible",
	};
	RELATE $user->ownsAsset->$asset;
	RELATE $user->created->$asset;
	RELATE $cached->createdAsset->$asset;
};
# Now time for the big one
LET $id = (UPDATE ONLY stuff:increment SET asset += 1).asset;
LET $cached = (SELECT data, type
FROM assetCache:[$assetId, $version])[0];
LET $asset = CREATE asset CONTENT {
	id: $id,
	name: $name,
	type: $cached.type,
	price: $price,
	description: [{
		text: $description,
		updated: time::now(),
	}],
	visibility: "Visible",
};
RELATE $user->ownsAsset->$asset;
RELATE $user->created->$asset;
{
	id: $id,
	type: $cached.type,
};
(SELECT
	(SELECT record::id(id) AS id
	FROM ->createdAsset->asset)[0].id AS id,
	type,
	record::id(id)[0] AS sharedId
FROM assetCache WHERE ->createdAsset->asset);
COMMIT TRANSACTION;
