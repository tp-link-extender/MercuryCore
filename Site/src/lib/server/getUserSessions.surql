SELECT *, meta::id(id) AS id FROM session
WHERE $user IN <-usingKey<-user;
