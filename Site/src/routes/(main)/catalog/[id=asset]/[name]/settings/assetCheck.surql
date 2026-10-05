SELECT
	(SELECT VALUE id FROM ONLY $parent<-created<-user) = $user AS isCreator,
	(SELECT VALUE record::id(id) FROM $parent->imageAsset->asset)[0] AS imageAssetId,
	type,
	name
FROM $asset;
