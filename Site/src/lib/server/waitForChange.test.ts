import { describe, expect, test } from "bun:test"
import { mkdtemp, rm, writeFile } from "node:fs/promises"
import { tmpdir } from "node:os"
import { join } from "node:path"
import { waitForChange } from "./waitForChange"

const withDir = async (run: (dir: string) => Promise<void>): Promise<void> => {
	const dir = await mkdtemp(join(tmpdir(), "waitForChange-"))
	try {
		await run(dir)
	} finally {
		await rm(dir, { force: true, recursive: true })
	}
}

describe("waitForChange", () => {
	test("resolves true when a matching file changes", () =>
		withDir(async dir => {
			const waiting = waitForChange(dir, 5000, name => name === "a.png")
			await writeFile(join(dir, "a.png"), "x")

			expect(await waiting).toBe(true)
		}))

	test("ignores changes that don't match", () =>
		withDir(async dir => {
			const waiting = waitForChange(dir, 200, name => name === "a.png")
			await writeFile(join(dir, "b.png"), "x")

			expect(await waiting).toBe(false)
		}))

	test("resolves false on timeout", () =>
		withDir(async dir => {
			expect(await waitForChange(dir, 50)).toBe(false)
		}))

	test("resolves false when the path can't be watched", async () => {
		expect(await waitForChange("/nonexistent/path/x", 5000)).toBe(false)
	})
})
