SELECT record::id(id) AS id, status, username FROM $usersList;
SELECT record::id(id) AS id, name FROM $groupsList;
SELECT record::id(id) AS id, name FROM $assetsList;
