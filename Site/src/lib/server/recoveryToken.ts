import { createHash, randomBytes } from "node:crypto"

/** Creates a new account recovery token, with 256 bits of randomness. It's 43 characters long, using the base64url alphabet. */
export const createRecoveryToken = (): string =>
	randomBytes(32).toString("base64url")

/** Hashes a recovery token for storage and lookup, so the database never holds a usable token. */
export const hashRecoveryToken = (token: string): string =>
	createHash("sha256").update(token).digest("hex")
