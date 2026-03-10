UPDATE (SELECT * FROM $user->playing) SET valid = false;
# todo: check ping is correct (server hasn't actually pung)
RELATE $user->playing->$place RETURN VALUE record::id(id);
