SELECT record::id(id) AS id, permissionLevel
FROM user WHERE username = $username;
