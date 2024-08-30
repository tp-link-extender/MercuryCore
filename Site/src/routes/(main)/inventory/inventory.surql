SELECT name, price, meta::id(id) AS id, type
FROM asset WHERE fn::filterInventory($this, $user)
LIMIT 50 START ($page - 1) * 50;

fn::clampPages(
	count(SELECT 1 FROM asset WHERE fn::filterInventory($this, $user)),
	50
);
