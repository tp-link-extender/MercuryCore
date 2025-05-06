SELECT
	*,
	record::id(id) AS id,
	(SELECT record::id(id) AS id, name
	FROM ->replyToAsset->asset)[0] AS parentAsset
FROM $assetComment;
