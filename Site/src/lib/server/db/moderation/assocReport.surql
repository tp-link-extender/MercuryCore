SELECT
	note,
	(SELECT username FROM $parent->user)[0].username AS reportee
FROM ONLY $report;
