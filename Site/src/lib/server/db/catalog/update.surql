LET $og = (SELECT name, fn::currentContent($this.description) AS description FROM ONLY $asset);
LET $changed = $og.name != $name OR $og.description != $description;

UPDATE $asset MERGE {
	name: $name,
	forSale: $forSale,
	price: $price,
};

IF $og.description != $description {
	UPDATE $asset SET description += {
		text: $description,
	};
};

# A changed name or description goes back to review, like a reupload, unless staff made the change
IF $changed AND $review {
	UPDATE $asset SET visibility = "Pending" WHERE visibility = "Visible";
};

$changed;
