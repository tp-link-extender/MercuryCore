SELECT record::id(id) AS id FROM forumCategory
WHERE string::lowercase(name) = string::lowercase($category);
