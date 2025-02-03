SELECT status, username
FROM array::concat($id->friends->user, $id<-friends<-user);
count($id->friends->user) + count($id<-friends<-user);
