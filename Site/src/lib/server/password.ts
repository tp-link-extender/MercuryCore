// Bun.password.hash and verify run on a worker thread, so hashing (argon2id, 64 MiB) doesn't block other requests the way hashSync and verifySync do.

let dummyHash: Promise<string> | undefined

/** Hashes a password for storage. */
export const hashPassword = (password: string): Promise<string> =>
	Bun.password.hash(password)

/**
 * Checks a password against a stored hash.
 * With no hash, for example when the user doesn't exist, it checks against a dummy hash and returns false, so the response takes as long as for a real user.
 */
export async function verifyPassword(
	password: string,
	hash: string | undefined
): Promise<boolean> {
	if (hash) return Bun.password.verify(password, hash)

	dummyHash ??= hashPassword(crypto.randomUUID())
	await Bun.password.verify(password, await dummyHash)
	return false
}
