// Query parameters that act as credentials, so they mustn't end up in logs
const secretParams =
	/([?&])(ticket|serverTicket|privateTicket|privateServer)=[^&#]*/gi

export const redactSearch = (search: string): string =>
	search.replaceAll(secretParams, "$1$2=[redacted]")
