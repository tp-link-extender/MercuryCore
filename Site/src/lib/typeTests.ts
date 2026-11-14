import { type } from "arktype"

const usernameRegex = /^[A-Za-z0-9_]+$/

export const usernameTest = type("3 <= string <= 21").and(
	type(usernameRegex).configure({
		problem: "must contain only alphanumeric characters or underscores",
	})
)

// A hostname (RFC 1123 labels) or an IPv4 address. Only these characters can reach the signed join script.
const hostnameRegex =
	/^(?=.{1,100}$)[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?(?:\.[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?)*$/

// All-numeric names like 300.1.1.1 match the hostname pattern, but they would be read as IPv4 addresses
const numericRegex = /^[0-9.]+$/

export const isValidServerAddress = (value: string): boolean =>
	type("string.ip")(value) === value ||
	(hostnameRegex.test(value) && !numericRegex.test(value))

export const serverAddressTest = type("string <= 100")
	.narrow(isValidServerAddress)
	.configure({ problem: "must be a valid domain name or IP address" })

export const serverPortTest = type("1024 <= number.integer <= 65535")

export const maxPlayersTest = type("1 <= number.integer <= 100")
