SELECT record::id(id) AS id, name, price FROM asset
WHERE fn::search(name, $query) AND type IN [2, 8, 11, 12, 17, 18, 19];
