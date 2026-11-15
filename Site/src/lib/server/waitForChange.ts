import fs from "node:fs"

/**
 * Waits until a file or directory changes, or until `timeoutMs` passes. The watcher is always closed, whichever comes first, so waits that time out don't leak watchers.
 * @param path The file or directory to watch.
 * @param timeoutMs How long to wait at most.
 * @param matches For a directory, which changed filenames count. Every change counts if omitted.
 * @returns true if the path changed, false if the wait timed out or the path couldn't be watched.
 */
export function waitForChange(
	path: string,
	timeoutMs: number,
	matches: (filename: string | null) => boolean = () => true
): Promise<boolean> {
	const { promise, resolve } = Promise.withResolvers<boolean>()

	let watcher: fs.FSWatcher
	try {
		watcher = fs.watch(path, (_, filename) => {
			if (matches(filename)) resolve(true)
		})
	} catch {
		return Promise.resolve(false)
	}
	watcher.on("error", () => resolve(false))
	const timer = setTimeout(() => resolve(false), timeoutMs)

	return promise.finally(() => {
		clearTimeout(timer)
		watcher.close()
	})
}
