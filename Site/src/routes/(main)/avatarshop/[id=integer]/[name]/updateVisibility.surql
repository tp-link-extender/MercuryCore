UPDATE $assetComment SET content += {
	text: $text,
	updated: time::now(),
};

UPDATE $assetComment SET visibility = $visibility;
