SELECT
	(SELECT VALUE id FROM ONLY $parent<-created<-user) = $user AS isCreator,
	record::id((->imageAsset->asset.id)[0]) AS imageAssetId,
	type,
	name
FROM $asset;
