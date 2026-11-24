!!SELECT 1 FROM recoveryCode WHERE hash = $hash AND expires > time::now();
