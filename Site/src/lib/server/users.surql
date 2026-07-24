SELECT record::id(id) AS id, status, username
FROM $usersList.filter(|$v| $v.id);
