SELECT 
	record::id(id) AS id,
	name,
	count(array::distinct(<-member<-user)) AS memberCount
FROM group
ORDER BY memberCount DESC, name ASC, id ASC
LIMIT 50 START ($page - 1) * 50;

fn::clampPages(
	count(SELECT 1 FROM group),
	50
);
