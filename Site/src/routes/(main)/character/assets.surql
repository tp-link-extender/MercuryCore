SELECT
	record::id(id) AS id,
	name,
	price,
	type,
	($user IN <-wearing<-user) AS wearing
FROM asset WHERE $user IN <-ownsAsset<-user
	AND type IN $allowedTypes
	AND visibility = "Visible";