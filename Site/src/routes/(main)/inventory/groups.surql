$is.map(|$i|
	SELECT record::id(id) AS id, name, count(<-member) AS memberCount FROM $i
);
