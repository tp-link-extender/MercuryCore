# Creates a package asset record and the asset records for everything inside it
# (children are inserted as their own records, and must be offsale)
# Note there's no ownership relation here: the package and its contents are owned in the Economy service, which the caller registers them with before running this query.

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
RELATE $user->created->$pkgRecord;

INSERT INTO asset $childRows;
RELATE $user->created->$childRecords;
RELATE $pkgRecord->packageItem->$childRecords;