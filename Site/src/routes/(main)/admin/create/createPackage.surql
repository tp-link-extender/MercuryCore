# Creates a package asset record and the asset records for everything inside it.
# Ownership and creator resolution live in the Economy service, so there are no relation writes here.

CREATE ONLY asset CONTENT {
	id: $id,
	description: [{
		text: $description,
	}],
	name: $name,
	price: $price,
	type: 32, # package
	visibility: "Visible",
};

INSERT INTO asset $childRows;
