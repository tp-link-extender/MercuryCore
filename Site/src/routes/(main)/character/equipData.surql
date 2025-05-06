SELECT record::id(id) AS id, type, visibility
FROM $asset WHERE $user IN <-owns<-user;
