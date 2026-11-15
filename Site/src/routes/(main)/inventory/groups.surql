SELECT record::id(id) AS id, name, count(array::distinct(<-member<-user)) AS memberCount
FROM group WHERE id IN $ids;
