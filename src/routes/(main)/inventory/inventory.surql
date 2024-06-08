SELECT
	name,
	price,
	meta::id(id) AS id,
	type
FROM asset WHERE $user IN <-owns<-user
	AND type IN [17, 18, 2, 11, 12, 19, 8]
	AND IF $query THEN
		string::lowercase($query) IN string::lowercase(name)
	ELSE
		TRUE
	END;
