SELECT id FROM group WHERE string::lowercase(name) = string::lowercase($name);
