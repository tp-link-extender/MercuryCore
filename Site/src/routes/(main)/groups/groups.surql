SELECT name, count(<-member) AS memberCount FROM group
LIMIT 50 START ($page - 1) * 50;

math::max([
	math::ceil(<float> count(SELECT 1 FROM group) / 50),
	1
]);
