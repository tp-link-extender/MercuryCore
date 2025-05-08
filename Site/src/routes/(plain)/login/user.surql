SELECT id, hashedPassword FROM user
WHERE string::lowercase(username) = string::lowercase($username);
