SELECT meta::id(id) AS id, name, price FROM asset
WHERE string::lowercase($searchQ) INSIDE string::lowercase(name)
	AND type INSIDE [17, 18, 2, 11, 12, 19, 8];
