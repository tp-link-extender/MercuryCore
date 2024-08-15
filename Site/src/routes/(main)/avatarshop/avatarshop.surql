SELECT meta::id(id) AS id, name, price, type
FROM asset WHERE visibility = "Visible"
AND IF $query THEN
	string::lowercase($query) IN string::lowercase(name)
ELSE
	TRUE
END;
