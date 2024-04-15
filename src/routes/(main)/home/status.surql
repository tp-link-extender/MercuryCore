LET $status = CREATE statusPost CONTENT {
	posted: time::now(),
	visibility: "Visible",
	content: [{
		text: $content,
		updated: time::now(),
	}],
};
RELATE $user->posted->$status;
