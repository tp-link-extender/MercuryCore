import { dbQuery } from "#lib/server/db/query.ts"
import { db, Record, type RecordId } from "#lib/server/surreal.ts"
import adminPasswordQuery from "./accounts/adminPassword.surql"
import adminUsersQuery from "./accounts/adminUsers.surql"
import changePasswordQuery from "./accounts/changePassword.surql"
import createInitialQuery from "./accounts/createInitial.surql"
import createUserQuery from "./accounts/createUser.surql"
import loginQuery from "./accounts/login.surql"
import passwordQuery from "./accounts/password.surql"
import profileQuery from "./accounts/profile.surql"
import recoveryQuery from "./accounts/recovery.surql"
import recoveryCheckQuery from "./accounts/recoveryCheck.surql"
import recoveryConsumeQuery from "./accounts/recoveryConsume.surql"
import registeredQuery from "./accounts/registered.surql"
import regKeyCheckQuery from "./accounts/regKeyCheck.surql"
import resetQuery from "./accounts/reset.surql"
import updateProfileQuery from "./accounts/updateProfile.surql"

export interface Profile {
	description: string | null
	// masked, as only the domain of the address is shown
	email: string
}

/**
 * Finds the account details that only the settings page shows, which the session doesn't carry.
 * @returns The profile, or undefined if there is no such user.
 */
export async function profileOf(id: string): Promise<Profile | undefined> {
	const [profile] = await dbQuery<Profile[]>(profileQuery, {
		user: Record("user", id),
	})
	// FROM ONLY gives null for a missing user, which is returned as undefined
	return profile ?? undefined
}

/**
 * Finds the id and password hash of the user with this username, for logging in.
 * @returns The user, or undefined if there is no such user.
 */
export async function findLoginUser(
	username: string
): Promise<{ id: RecordId<"user">; hashedPassword: string } | undefined> {
	const [[user]] = await dbQuery<
		{ id: RecordId<"user">; hashedPassword: string }[][]
	>(loginQuery, { username })
	return user
}

/** Finds whether any account has been registered yet. */
export async function accountRegistered(): Promise<boolean> {
	const [registered] = await dbQuery<boolean[]>(registeredQuery)
	return registered
}

/**
 * Finds how many uses a registration key has left.
 * @returns The key's uses, or undefined if the key is unknown, expired or missing.
 */
export async function regKeyUsesLeft(
	key: RecordId<"regKey">
): Promise<{ usesLeft: number } | undefined> {
	const [[regkey]] = await dbQuery<{ usesLeft: number }[][]>(
		regKeyCheckQuery,
		{ key }
	)
	return regkey
}

export interface NewUser {
	bodyColours: { [_: string]: number }
	email?: string
	hashedPassword: string
	key?: RecordId<"regKey">
	permissionLevel?: number
	username: string
}

/**
 * Creates a user, using up a use of their registration key if they have one.
 * @returns The new user's id, or undefined if the key had no uses left.
 */
export async function createUser(
	user: NewUser
): Promise<RecordId<"user"> | undefined> {
	const results = await dbQuery<RecordId<"user">[]>(createUserQuery, {
		bodyColours: user.bodyColours,
		email: user.email || "",
		hashedPassword: user.hashedPassword,
		key: user.key,
		permissionLevel: user.permissionLevel ?? 1,
		username: user.username,
	})
	return results.at(-1)
}

/**
 * Creates the first account, which is only allowed while no accounts exist.
 * @returns The new user's id, or undefined if the transaction didn't create one.
 */
export async function createInitialAccount(user: {
	bodyColours: { [_: string]: number }
	hashedPassword: string
	username: string
}): Promise<RecordId<"user"> | undefined> {
	const results = await dbQuery<RecordId<"user">[]>(createInitialQuery, user)
	// The last result is COMMIT's, so the user is the one before it
	return results.at(-2)
}

/**
 * Creates a recovery token for the account with this email address, replacing any it already had.
 * Nothing is stored if no account uses the address, so the caller can't tell whether it does.
 * @returns Whether a token was created.
 */
export async function issueRecoveryToken(
	email: string,
	hash: string
): Promise<boolean> {
	// oxlint-disable-next-line unicorn/no-unreadable-array-destructuring -- query returns [let, if, exists]
	const [, , exists] = await dbQuery<boolean[]>(recoveryQuery, {
		email,
		hash,
	})
	return exists
}

/** Finds whether a recovery token is valid, without using it up. */
export async function recoveryTokenValid(hash: string): Promise<boolean> {
	const [valid] = await dbQuery<boolean[]>(recoveryCheckQuery, { hash })
	return valid
}

/**
 * Uses up a recovery token, so it can only be used once.
 * @returns The user the token was for, or undefined if it's invalid or expired.
 */
export async function consumeRecoveryToken(
	hash: string
): Promise<RecordId<"user"> | undefined> {
	const [user] = await dbQuery<(RecordId<"user"> | undefined)[]>(
		recoveryConsumeQuery,
		{ hash }
	)
	return user
}

/** Changes a user's password and logs them out everywhere, as whoever had the old password may still be signed in. */
export async function resetPassword(
	user: RecordId<"user">,
	hashedPassword: string
): Promise<void> {
	await dbQuery(resetQuery, { hashedPassword, user })
}

/**
 * Finds a user's password hash, to check the password they enter against.
 * Throws if there is no such user, which can't happen for a signed-in user.
 */
export async function passwordHashOf(id: string): Promise<string> {
	const [[{ hashedPassword }]] = await dbQuery<
		{ hashedPassword: string }[][]
	>(passwordQuery, { user: Record("user", id) })
	return hashedPassword
}

export async function changePassword(
	id: string,
	hashedPassword: string
): Promise<void> {
	await dbQuery(changePasswordQuery, {
		hashedPassword,
		user: Record("user", id),
	})
}

export async function updateProfile(
	id: string,
	profile: { description?: string; theme: number }
): Promise<void> {
	await dbQuery(updateProfileQuery, {
		description: profile.description,
		theme: profile.theme,
		user: Record("user", id),
	})
}

export async function setCss(id: string, css?: string): Promise<void> {
	await db.update(Record("user", id)).merge({ css })
}

/** Lists every user who isn't moderated, for an administrator choosing whose password to change. */
export async function unmoderatedUsers(): Promise<BasicUser[]> {
	const [users] = await dbQuery<BasicUser[][]>(adminUsersQuery)
	return users
}

/**
 * Sets the password of the user with this username, and logs them out everywhere.
 * @returns Whether a user with this username was found.
 */
export async function setPasswordOf(
	username: string,
	hashedPassword: string
): Promise<boolean> {
	// oxlint-disable-next-line unicorn/no-unreadable-array-destructuring -- the query returns [result, loop result, ok]
	const [, , ok] = await dbQuery<boolean[]>(adminPasswordQuery, {
		npassword: hashedPassword,
		username,
	})
	return ok
}
