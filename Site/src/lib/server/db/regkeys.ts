import { dbQuery } from "#lib/server/db/query.ts"
import { Record, type RecordId } from "#lib/server/surreal.ts"
import createQuery from "./regkeys/create.surql"
import disableQuery from "./regkeys/disable.surql"
import disabledQuery from "./regkeys/disabled.surql"
import listQuery from "./regkeys/list.surql"

export interface RegKey {
	created: string
	creator?: BasicUser
	expiry: Date | string | null
	id: string
	usesLeft: number
}

/** Lists every registration key, newest first. */
export async function regKeysOf(): Promise<RegKey[]> {
	const [regKeys] = await dbQuery<RegKey[][]>(listQuery)
	return regKeys
}

/**
 * Creates a registration key.
 * @throws AlreadyExistsError if a key with the custom name already exists.
 */
export async function createRegKey(args: {
	creator: RecordId<"user">
	expiry?: Date
	regKeyCustom?: string
	regKeyUses: number
}): Promise<void> {
	await dbQuery(createQuery, args)
}

/**
 * Finds whether a registration key is disabled, which is when it has no uses left.
 * @returns Whether it's disabled, or undefined if there is no such key.
 */
export async function regKeyDisabledOf(
	id: string
): Promise<boolean | undefined> {
	const [[key]] = await dbQuery<{ disabled: boolean }[][]>(disabledQuery, {
		regKey: Record("regKey", id),
	})
	return key?.disabled
}

/** Disables a registration key, which is logged by the administrator who did it. */
export async function disableRegKey(
	id: string,
	user: RecordId<"user">
): Promise<void> {
	await dbQuery(disableQuery, {
		msg: `Disable registration key ${id}`,
		regKey: Record("regKey", id),
		user,
	})
}
