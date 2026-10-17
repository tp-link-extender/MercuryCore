# Items inside a package aren't listed separately, so $packageItems (their ids, from the Economy service) is excluded here rather than relying on a database relation

SELECT name, price, record::id(id) AS id
FROM asset WHERE visibility = "Visible" AND type = $type AND forSale
	AND record::id(id) NOT IN $packageItems
LIMIT 50 START ($page - 1) * 50;

# TODO: the pagination doesn't actually work like this for the catalog
fn::clampPages(
	count(SELECT 1 FROM asset WHERE visibility = "Visible" AND type = $type AND forSale
		AND record::id(id) NOT IN $packageItems),
	50
);