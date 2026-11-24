SELECT status, username FROM user WHERE fn::search(username, $query);
