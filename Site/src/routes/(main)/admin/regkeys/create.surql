CREATE $regKey CONTENT {
	usesLeft: $regKeyUses,
	expiry: $expiry,
	created: time::now(),
	creator: $creator,
}