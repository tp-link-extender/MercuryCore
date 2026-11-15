# A new link when the place becomes private, so links seen while it was public stop working
LET $wasPrivate = (SELECT VALUE privateServer FROM ONLY $place);
UPDATE $place SET
	privateServer = $privateServer,
	privateTicket = IF $privateServer AND !$wasPrivate {
		rand::id()
	} ELSE {
		privateTicket
	};
