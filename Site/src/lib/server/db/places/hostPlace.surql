SELECT record::id(id) AS id, serverPort FROM place WHERE serverTicket = $ticket;
