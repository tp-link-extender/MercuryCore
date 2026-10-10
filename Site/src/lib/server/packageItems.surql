# Used to gather the contents of a package (nested packages are reported via the nested field)

SELECT record::id(id) AS id, type, visibility,
	$user IN <-ownsAsset<-user.id AS owned,
	count(->packageItem) AS nested
FROM $pkg->packageItem->asset;
