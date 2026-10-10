SELECT
	record::id(id) AS id,
	name,
	price,
	type,
	($user IN <-wearing<-user) AS wearing
FROM $assets
WHERE type IN $allowedTypes
	AND visibility = "Visible";