SELECT number, status, username FROM user
WHERE string::lowercase($searchQ) INSIDE string::lowercase(username);
