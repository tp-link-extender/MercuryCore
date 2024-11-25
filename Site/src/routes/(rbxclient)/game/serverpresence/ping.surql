UPDATE place SET serverPing = time::unix() WHERE serverTicket = $ticket;
