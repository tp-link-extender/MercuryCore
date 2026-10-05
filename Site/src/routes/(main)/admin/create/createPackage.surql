# Creates a package asset and all of the assets inside it
# (children are inserted as their own records, and must be offsale)

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
RELATE $user->ownsAsset->$pkgRecord;
RELATE $user->created->$pkgRecord;

INSERT INTO asset $childRows;
RELATE $user->ownsAsset->$childRecords;
RELATE $user->created->$childRecords;
RELATE $pkgRecord->packageItem->$childRecords;
