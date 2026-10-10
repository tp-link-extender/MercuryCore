CREATE ONLY asset CONTENT {
	id: $id,
	description: [{
		text: $description,
	}],
	name: $name,
	price: $price,
	type: $assetType,
	visibility: "Visible", # admin, immediately visible
};
