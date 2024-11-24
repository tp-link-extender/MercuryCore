UPDATE $render MERGE {
	status: "Completed",
	completed: time::now(),
};
