LET $og = SELECT VALUE fn::currentContent($this.description) FROM $place;

UPDATE $place SET name = $name;

IF $og != $description {
	UPDATE $place SET description += {
		text: $description,
	};
};
