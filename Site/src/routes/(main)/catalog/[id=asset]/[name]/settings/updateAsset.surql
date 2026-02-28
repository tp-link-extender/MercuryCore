LET $og = SELECT
	(SELECT text, updated FROM $parent.description
	ORDER BY updated)[$] AS description
FROM $asset;

UPDATE $asset MERGE {
	name: $name,
	forSale: $forSale,
	price: $price,
};

IF $og.description.text != $description {
	UPDATE $asset SET description += {
		text: $description,
	};
};
