SELECT
	(SELECT VALUE id FROM ONLY $parent<-created<-user) = $user AS isCreator
FROM $asset;
