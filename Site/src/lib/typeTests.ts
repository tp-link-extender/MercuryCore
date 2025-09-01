import { type } from "arktype"

const usernameRegex = /^[A-Za-z0-9_]+$/

export const usernameTest = type("3 <= string <= 21").and(
	type(usernameRegex).configure({
		problem: "must contain only alphanumeric characters or underscores",
	})
)

// TODO: come back to this when there's actually a good way to validate
export const serverAddressTest = type("string <= 100").configure({
	problem: "must be a valid domain name or IP address",
})

export const serverPortTest = type("1024 <= number.integer <= 65535")

export const maxPlayersTest = type("1 <= number.integer <= 100")
