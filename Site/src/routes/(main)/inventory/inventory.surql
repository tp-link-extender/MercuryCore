DEFINE FUNCTION fn::inventoryCheck($thing: object) {
	RETURN $user IN $thing<-owns<-user
		AND $thing.type IN [2, 8, 11, 12, 17, 18, 19]
		AND IF $query THEN
			string::lowercase($query) IN string::lowercase($thing.name)
		ELSE
			TRUE
		END
};

SELECT name, price, meta::id(id) AS id, type
FROM asset WHERE fn::inventoryCheck($this)
LIMIT 50 START ($page - 1) * 50;

fn::clampPages(count(SELECT 1 FROM asset WHERE fn::inventoryCheck($this)), 50);
