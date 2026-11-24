import { dbQuery } from "#lib/server/db/query.ts"
import { db, Record } from "#lib/server/surreal.ts"
import completeQuery from "./renders/complete.surql"
import createQuery from "./renders/create.surql"
import pingQuery from "./renders/ping.surql"
import statusQuery from "./renders/status.surql"
import taskQuery from "./renders/task.surql"

export type RenderType =
	| "Clothing"
	| "Avatar"
	| "Model"
	| "Mesh"
	| "Package"
	| "Torso"
	| "LeftArm"
	| "RightArm"
	| "LeftLeg"
	| "RightLeg"
export type Status = "Pending" | "Rendering" | "Completed" | "Error"

export interface RenderTask {
	relativeId: number
	type:
		| "Clothing"
		| "Avatar"
		| "Package"
		| "Torso"
		| "LeftArm"
		| "RightArm"
		| "LeftLeg"
		| "RightLeg"
}

/**
 * Finds the status of a render of this asset or avatar that is pending or rendering, if there is one.
 * @param relativeId The id of the asset, or the user for an avatar.
 * @param renderType The kind of render.
 * @returns The status, or undefined if there is no such render.
 */
export async function activeRenderStatus(
	relativeId: string | number,
	renderType: RenderType
): Promise<Status | undefined> {
	// oxlint-disable-next-line unicorn/no-unreadable-array-destructuring -- query returns [result, error, value]
	const [, , render] = await dbQuery<{ status: Status }[]>(statusQuery, {
		relativeId,
		renderType,
	})
	return render?.status
}

/**
 * Creates a pending render record.
 * @returns The id of the new render, which the RCCService proxy uses to report back.
 */
export async function createRender(
	relativeId: string | number,
	renderType: RenderType
): Promise<string> {
	const [, renderId] = await dbQuery<string[]>(createQuery, {
		relativeId,
		renderType,
	})
	if (!renderId) throw new Error("Failed to create render record")
	return renderId
}

export async function failRender(id: string): Promise<void> {
	await db.update(Record("render", id)).merge({ status: "Error" })
}

export async function markRendering(id: string): Promise<void> {
	await db.update(Record("render", id)).merge({ status: "Rendering" })
}

export async function completeRender(id: string): Promise<void> {
	await dbQuery(completeQuery, { render: Record("render", id) })
}

export async function renderTask(id: string): Promise<RenderTask | undefined> {
	const [[task]] = await dbQuery<RenderTask[][]>(taskQuery, {
		render: Record("render", id),
	})
	return task
}

export async function pingRenderer(): Promise<void> {
	await dbQuery(pingQuery)
}
