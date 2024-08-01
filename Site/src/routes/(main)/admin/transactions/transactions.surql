SELECT
	amountSent,
	link,
	note,
	taxRate,
	time,
	(SELECT status, username FROM in.*)[0] AS sender,
	(SELECT status, username FROM out.*)[0] AS receiver
FROM transaction;
