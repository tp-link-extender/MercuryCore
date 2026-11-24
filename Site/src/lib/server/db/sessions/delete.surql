DELETE session WHERE expires < time::now();
DELETE $sess;

