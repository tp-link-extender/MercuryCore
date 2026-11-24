UPDATE $user SET lastOnline = time::now();
!!SELECT 1 FROM moderation WHERE out = $user AND active;
