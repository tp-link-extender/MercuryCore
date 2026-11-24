SELECT status, username FROM user WHERE $user IN ->request->user
ORDER BY username ASC
LIMIT 50 START ($page - 1) * 50;

fn::clampPages(
	count(SELECT 1 FROM user WHERE $user IN ->request->user),
	50
);
