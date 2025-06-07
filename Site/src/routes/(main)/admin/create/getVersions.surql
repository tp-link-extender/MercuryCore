FOR $version IN $versions {
	UPSERT type::thing("assetCache", $version.id) MERGE {
		# what on earth do I name this field?
		# cache invalidation AND naming things in the same query?
		assetModified: $version.assetModified,
		description: $version.description,
		name: $version.name,
		type: $version.type,
	}
};
