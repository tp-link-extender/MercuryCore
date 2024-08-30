SELECT meta::id(id) AS id, name, price, type
FROM asset WHERE visibility = "Visible"
LIMIT 50 START ($page - 1) * 50;

fn::clampPages(
	count(SELECT 1 FROM asset WHERE visibility = "Visible")
	50
);
