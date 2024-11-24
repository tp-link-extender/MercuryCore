UPDATE (SELECT * FROM $user->playing) SET valid = false;
RELATE $user->playing->$place CONTENT {
	ping: time::now(), # todo: check
	valid: true,
} RETURN meta::id(id) AS id;
