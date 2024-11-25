SELECT meta::id(id) AS id, type, visibility
FROM $asset WHERE $user IN <-owns<-user;
