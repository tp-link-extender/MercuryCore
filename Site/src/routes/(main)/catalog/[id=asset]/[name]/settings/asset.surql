SELECT
	*,
	record::id(id) AS id,
	(SELECT status, username FROM $parent<-created<-user)[0] AS creator,

	fn::currentContent($this.description) AS description
FROM $asset;
