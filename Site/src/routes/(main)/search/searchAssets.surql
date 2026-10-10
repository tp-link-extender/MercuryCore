SELECT record::id(id) AS id, name, price FROM asset
WHERE fn::search(name, $query) AND type IN [2, 8, 11, 12, 17, 18, 19, 32]
	AND count(<-packageItem) = 0; # items inside a package aren't searchable on their own
