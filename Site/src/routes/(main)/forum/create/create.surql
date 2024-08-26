LET $post = CREATE $postId CONTENT {
	title: $title,
	posted: time::now(),
	visibility: "Visible",
	pinned: false, # otherwise the post sorting would sort by [true, false, null] and you'll get random ordering on posts that have been unpinned
	content: [{
		text: $content,
		updated: time::now(),
	}],
};
RELATE $post->in->$category;
RELATE $user->created->$post;
