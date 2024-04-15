SELECT
	*,
	(SELECT number, status, username FROM in.*)[0] AS sender,
	(SELECT number, status, username FROM out.*)[0] AS receiver
FROM transaction;
