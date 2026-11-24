import { dbQuery } from "#lib/server/db/query.ts"
import bodyColoursQuery from "./appearance/bodyColours.surql"
import wornAssetsQuery from "./appearance/wornAssets.surql"

export interface BodyColours {
	Head: number
	LeftArm: number
	LeftLeg: number
	RightArm: number
	RightLeg: number
	Torso: number
}

/**
 * Finds the body colours of a user, which the character appearance is built from.
 * @returns The body colours, or undefined if there is no such user.
 */
export async function bodyColoursOf(
	username: string
): Promise<BodyColours | undefined> {
	const [[user]] = await dbQuery<{ bodyColours: BodyColours }[][]>(
		bodyColoursQuery,
		{ username }
	)
	return user?.bodyColours
}

/**
 * Finds the ids of the assets a user is wearing.
 * @returns The asset ids, or undefined if there is no such user.
 */
export async function wornAssetsOf(
	username: string
): Promise<number[] | undefined> {
	const [[user]] = await dbQuery<{ wearing: number[] }[][]>(wornAssetsQuery, {
		username,
	})
	return user?.wearing
}
