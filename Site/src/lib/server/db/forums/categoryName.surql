SELECT name FROM forumCategory
WHERE string::lowercase(name) = string::lowercase($categoryParam);
