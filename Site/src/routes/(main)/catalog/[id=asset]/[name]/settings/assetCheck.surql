SELECT
	(SELECT VALUE id FROM ONLY $parent<-created<-user) = $user AS isCreator,
	(SELECT record::id(id) AS id FROM $parent->imageAsset->asset)[0].id AS imageAssetId,
	type,
	name
FROM $asset;
