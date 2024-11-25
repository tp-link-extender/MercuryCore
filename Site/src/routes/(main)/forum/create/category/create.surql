CREATE type::thing("forumCategory", $name) CONTENT {
	name: $name,
	description: $description,
	created: time::now(),
};
