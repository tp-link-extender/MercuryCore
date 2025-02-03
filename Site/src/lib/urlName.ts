// Allows names to be used in URLs, used by place names
// todo: consider lovell/limax

export const encode = (str: string) =>
	str.replace(/[^a-zA-Z0-9]/g, "-").replace(/-+/g, "-")
export const couldMatch = (str: string, match: string) => encode(str) === match
