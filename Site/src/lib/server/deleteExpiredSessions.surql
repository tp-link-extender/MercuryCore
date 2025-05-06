DELETE session WHERE expiresAt < time::now();
