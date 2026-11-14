UPDATE $user SET hashedPassword = $hashedPassword;
# Log out everywhere, in case someone else has a session. The caller makes a new one for the user.
DELETE session WHERE $user IN <-hasSession<-user;
