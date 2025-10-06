SELECT 
	meta::id(id) AS id,
	name,
	count(<-member) AS memberCount
FROM group
LIMIT 50 START ($page - 1) * 50;

fn::clampPages(
	count(SELECT 1 FROM group),
	50
);
