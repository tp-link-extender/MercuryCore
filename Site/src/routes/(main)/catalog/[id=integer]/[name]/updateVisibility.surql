UPDATE $assetComment SET content += {
	text: $text,
	updated: time::now(),
}, visibility = $visibility;
