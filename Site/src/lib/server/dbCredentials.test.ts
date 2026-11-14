import { describe, expect, test } from "bun:test"
import {
	CredentialError,
	checkPassword,
	checkUser,
	databaseCredentials,
	defaultUser,
	minPasswordLength,
} from "./dbCredentials"

const good = "a".repeat(minPasswordLength)

describe("checkPassword", () => {
	test("accepts a hex password from openssl rand -hex 32", () => {
		const hex = "0f3a9c".repeat(11)
		expect(checkPassword("X", hex)).toBe(hex)
	})

	test("accepts letters, digits, underscores and hyphens", () => {
		const value = `${good}AZaz09_-`
		expect(checkPassword("X", value)).toBe(value)
	})

	test("rejects a missing or empty password", () => {
		expect(() => checkPassword("X", undefined)).toThrow(CredentialError)
		expect(() => checkPassword("X", "")).toThrow(CredentialError)
	})

	test("rejects a short password", () => {
		expect(() => checkPassword("X", good.slice(1))).toThrow(CredentialError)
		expect(() => checkPassword("X", "root")).toThrow(CredentialError)
	})

	test("rejects characters that could break out of a SurrealQL string", () => {
		for (const c of ["'", '"', "\\", "`", ";", " ", "\n", "⟩", "é"])
			expect(() => checkPassword("X", `${good}${c}`)).toThrow(
				CredentialError
			)
	})

	test("never includes the value in the message", () => {
		const secret = `${"s3cret".repeat(6)}'`
		try {
			checkPassword("DATABASE_PASSWORD", secret)
		} catch (err) {
			if (!(err instanceof Error)) throw err
			expect(err.message).toContain("DATABASE_PASSWORD")
			expect(err.message).not.toContain("s3cret")
			return
		}
		throw new Error("expected checkPassword to throw")
	})
})

describe("checkUser", () => {
	test("defaults to the site user", () => {
		expect(checkUser(undefined)).toBe(defaultUser)
		expect(checkUser("")).toBe(defaultUser)
	})

	test("accepts identifiers", () => {
		expect(checkUser("mercury_site2")).toBe("mercury_site2")
	})

	test("rejects root and non-identifiers", () => {
		for (const user of ["root", "2site", "si te", "site;", "site'"])
			expect(() => checkUser(user)).toThrow(CredentialError)
	})
})

describe("databaseCredentials", () => {
	test("reads the user and password", () => {
		expect(
			databaseCredentials({
				DATABASE_PASSWORD: good,
				DATABASE_USER: "web",
			})
		).toEqual({ password: good, user: "web" })
	})

	test("requires a password", () => {
		expect(() => databaseCredentials({})).toThrow(CredentialError)
	})
})
