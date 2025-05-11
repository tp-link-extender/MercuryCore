SELECT name, price, record::id(id) AS id, type
FROM asset WHERE visibility = "Visible"
LIMIT 50 START ($page - 1) * 50;

# TODO: the pagination doesn't actually work like this for the catalog
fn::clampPages(
	count(SELECT 1 FROM asset WHERE visibility = "Visible"),
	50
);
