SELECT
	meta::id(id) AS id,
	name,
	price,
	type,
	<-owns<-user AS owners
FROM asset WHERE $user IN <-owns<-user
	AND type IN [17, 18, 2, 11, 12, 19, 8]
	AND IF $query THEN
		string::lowercase($query) IN string::lowercase(name)
	ELSE
		TRUE
	END;
