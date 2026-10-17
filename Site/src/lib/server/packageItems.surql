# Used to gather the contents of a package (nested packages are reported via the nested field)
# ownership is NOT queried here - it lives in the Economy service, and packageItems.ts fills it in

SELECT record::id(id) AS id, type, visibility,
	count(->packageItem) AS nested
FROM $pkg->packageItem->asset;