SELECT status, username FROM user
WHERE string::lowercase($query) IN string::lowercase(username);
