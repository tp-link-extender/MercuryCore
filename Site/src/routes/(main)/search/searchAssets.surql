# Items inside a package aren't searchable on their own, so $packageItems (their ids, from the Economy service) is excluded here rather than relying on a database relation

SELECT record::id(id) AS id, name, price FROM asset
WHERE fn::search(name, $query) AND type IN [2, 8, 11, 12, 17, 18, 19, 32]
	AND record::id(id) NOT IN $packageItems;