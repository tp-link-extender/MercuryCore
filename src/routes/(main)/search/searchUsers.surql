SELECT number, status, username FROM user
WHERE string::lowercase($searchQ) IN string::lowercase(username);
