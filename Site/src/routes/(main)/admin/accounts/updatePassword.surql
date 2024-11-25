UPDATE user SET hashedPassword = $npassword
WHERE $username ~ username;
