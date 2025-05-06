SELECT *, record::id(id) AS id FROM session
WHERE $user IN <-usingKey<-user;
