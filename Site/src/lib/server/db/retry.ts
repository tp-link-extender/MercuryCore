const retriable = "This transaction can be retried"

/**
 * Runs a database operation again once if SurrealDB asks for the transaction to be retried.
 * This has no imports so that it can be used by the connection code as well as the query layer.
 * @param run The operation to run, which is run again if it fails with a retriable error.
 * @returns The result of the operation.
 */
export const retryOnConflict = async <T>(
	run: () => PromiseLike<T>
): Promise<T> => {
	try {
		return await run()
	} catch (err) {
		if (!(err instanceof Error) || !err.message.endsWith(retriable))
			throw err
		console.log("Retrying query:", err.message)
	}
	return run()
}
