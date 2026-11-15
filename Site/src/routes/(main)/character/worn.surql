# Used to check which of an array of assets (a package's contents) the user is wearing

SELECT record::id(id) AS id, $user IN <-wearing<-user AS worn
FROM asset WHERE record::id(id) IN $ids;
