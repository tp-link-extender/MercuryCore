LET $og = SELECT VALUE fn::currentContent($this.description) FROM $asset;

UPDATE $asset MERGE {
	name: $name,
	forSale: $forSale,
	price: $price,
};

IF $og != $description {
	UPDATE $asset SET description += {
		text: $description,
	};
};
