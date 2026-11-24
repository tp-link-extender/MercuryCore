SELECT id, hashedPassword FROM user
WHERE usernameLower = string::lowercase($username);
