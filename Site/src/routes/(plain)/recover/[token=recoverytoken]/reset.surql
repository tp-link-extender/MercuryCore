UPDATE $user SET hashedPassword = $hashedPassword;
DELETE recoveryCode WHERE user = $user;
# Log out everywhere, in case whoever had the old password still has a session
DELETE session WHERE $user IN <-hasSession<-user;
