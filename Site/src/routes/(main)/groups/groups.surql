SELECT name, count(<-member) AS memberCount
FROM group WHERE IF $query THEN
		string::lowercase($query) IN string::lowercase(name)
	ELSE
		TRUE
	END
LIMIT 50 START ($page - 1) * 50;

math::max([
	math::ceil(<float> count(SELECT 1 FROM group WHERE IF $query THEN
			string::lowercase($query) IN string::lowercase(name)
		ELSE
			TRUE
		END) / 50),
	1
]);
