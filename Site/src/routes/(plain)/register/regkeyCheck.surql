SELECT usesLeft FROM $key WHERE expiry IS NONE OR expiry > time::now();
