# Fetches the database details of a package's contents, given their ids from the Economy service.
# Ownership is not queried here - it's in the Economy service too.

SELECT record::id(id) AS id, name, type, visibility
FROM asset WHERE id IN $ids;