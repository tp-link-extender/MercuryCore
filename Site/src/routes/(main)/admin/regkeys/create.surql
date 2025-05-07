CREATE type::thing("regKey", $regKeyCustom OR rand::guid()) CONTENT {
	creator: $creator,
	expiry: $expiry,
	usesLeft: $regKeyUses,
};
