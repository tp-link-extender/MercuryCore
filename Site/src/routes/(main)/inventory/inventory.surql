SELECT
	name,
	price,
	meta::id(id) AS id,
	type
FROM asset WHERE $user IN <-owns<-user
	AND type IN [2, 8, 11, 12, 17, 18, 19]
	AND IF $query THEN
		string::lowercase($query) IN string::lowercase(name)
	ELSE
		TRUE
	END
LIMIT 50 START ($page - 1) * 50;

math::max([
	math::ceil(<float> count(SELECT 1 FROM asset WHERE $user IN <-owns<-user
		AND type IN [2, 8, 11, 12, 17, 18, 19]
		AND IF $query THEN
			string::lowercase($query) IN string::lowercase(name)
		ELSE
			TRUE
		END) / 50),
	1
]);
