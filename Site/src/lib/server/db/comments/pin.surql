UPDATE $comment SET pinned = $pinned
	WHERE type != ["status"] RETURN VALUE 1;
