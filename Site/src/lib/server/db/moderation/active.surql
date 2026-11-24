SELECT type, note, time, timeEnds FROM moderation
WHERE out = $user AND active = true;
