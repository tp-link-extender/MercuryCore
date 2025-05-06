FOR $version IN $versions {
	# can't do assetCache:$version.id or :($version.id) for some reason
	# array record ids still hella useful though
	UPDATE assetCache:[$version.id[0], $version.id[1]] CONTENT {
		# what on earth do I name this field?
		# cache invalidation AND naming things in the same query?
		assetModified: $version.assetModified,
		description: $version.description,
		name: $version.name,
		type: $version.type,
	}
};
