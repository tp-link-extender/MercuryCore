SELECT
	note,
	(SELECT username FROM ->user)[0].username AS reportee
FROM ONLY $report;
