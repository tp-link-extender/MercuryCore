CREATE auditLog CONTENT {
	action: $action,
	note: $note,
	user: $user,
	time: time::now()
};
