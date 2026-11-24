import { retryOnConflict } from "#lib/server/db/retry.ts"
import { db } from "#lib/server/surreal.ts"

/**
 * Runs SurrealQL and returns one result per statement, retrying once if SurrealDB asks for it.
 * This is the only way route and library code should query the database. It is named dbQuery because SvelteKit's remote functions already export query.
 * @param sql The SurrealQL to run, usually imported from a .surql file.
 * @param bindings The values the query refers to as $names.
 * @returns A tuple with one result per statement.
 * @example
 * const [[user]] = await dbQuery<User[][]>(userQuery, { username })
 */
// The return type is inferred because the SDK's result is a mapped type over R, which TypeScript only resolves for concrete R. Inferring it gives callers the same type as db.query.
export const dbQuery = <R extends unknown[] = unknown[]>(
	sql: string,
	bindings?: { [_: string]: unknown }
) => retryOnConflict(() => db.query<R>(sql, bindings))
