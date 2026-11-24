# Worn items stay listed even when they're no longer visible, so they can still be taken off

SELECT
	record::id(id) AS id,
	name,
	price,
	type,
	($user IN <-wearing<-user) AS wearing
FROM $assets
WHERE type IN $allowedTypes
	AND (visibility = "Visible" OR $user IN <-wearing<-user);