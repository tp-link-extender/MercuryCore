CREATE type::record("regKey", $regKeyCustom OR rand::id()) CONTENT {
	creator: $creator,
	expiry: $expiry,
	usesLeft: $regKeyUses,
};
