LET $og = SELECT VALUE fn::currentContent($this.description) FROM $user;

UPDATE $user SET theme = $theme;

IF $og != $description {
	UPDATE $user SET description += {
		text: $description,
	};
};
