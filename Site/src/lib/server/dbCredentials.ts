// Passwords end up as literals in DEFINE USER and ALTER USER statements, which take no parameters, so they are restricted to characters that can't break out of a string
const passwordPattern = /^[A-Za-z0-9_-]+$/
const userPattern = /^[A-Za-z_][A-Za-z0-9_]*$/
export const minPasswordLength = 32
export const defaultUser = "site"

export class CredentialError extends Error {
	override name = "CredentialError"
}

interface Env {
	[_: string]: string | undefined
}

export interface DatabaseCredentials {
	password: string
	user: string
}

/**
 * Checks that a password is set, long enough and only uses characters that are safe inside a SurrealQL string. Error messages never include the value.
 * @param name The environment variable the password came from, used in error messages.
 * @param value The password.
 * @returns The password, if it is valid.
 */
export function checkPassword(name: string, value: string | undefined): string {
	const generate = "Generate one with `openssl rand -hex 32`."
	if (!value) throw new CredentialError(`${name} is not set. ${generate}`)
	if (value.length < minPasswordLength)
		throw new CredentialError(
			`${name} must be at least ${minPasswordLength} characters long. ${generate}`
		)
	if (!passwordPattern.test(value))
		throw new CredentialError(
			`${name} may only contain letters, digits, underscores and hyphens. ${generate}`
		)
	return value
}

/**
 * Checks that a database username is a plain identifier.
 * @param value The username, or undefined for the default.
 * @returns The username, if it is valid.
 */
export function checkUser(value: string | undefined): string {
	const user = value || defaultUser
	if (!userPattern.test(user))
		throw new CredentialError(
			"DATABASE_USER may only contain letters, digits and underscores, and can't start with a digit."
		)
	if (user === "root")
		throw new CredentialError(
			"DATABASE_USER can't be root. The Site connects as a user limited to its own database."
		)
	return user
}

export const databaseCredentials = (env: Env): DatabaseCredentials =>
	Object.freeze({
		password: checkPassword("DATABASE_PASSWORD", env.DATABASE_PASSWORD),
		user: checkUser(env.DATABASE_USER),
	})

export const rootPassword = (env: Env): string =>
	checkPassword("DATABASE_ROOT_PASSWORD", env.DATABASE_ROOT_PASSWORD)
