SELECT meta::id(id) AS id, name, price FROM asset
WHERE name ~ $query AND type IN [17, 18, 2, 11, 12, 19, 8];
