let started = false

export default async () => {
	if (started) return
	started = true
	console.log("Starting SurrealDB...")

	try {
		const proc = Bun.spawn(
			[
				"surreal",
				"start",
				"-u=root",
				"-p=root",
				"surrealkv://data/surreal",
			],
			{ cwd: "..", stdout: "pipe", stderr: "pipe" }
		)

		process.on("exit", () => {
			console.log("Shutting down SurrealDB...")
			proc.kill()
		})

		proc.exited.then(async () => {
			console.error("SurrealDB process exited unexpectedly.")
			const r = await proc.stderr.getReader().read()
			const logs = new TextDecoder().decode(r.value)
			console.log(logs.split("\n").slice(-10).join("\n"))
			process.exit(1)
		})
	} catch {
		console.error(
			"Failed to start SurrealDB. Please make sure it is installed and accessible as `surreal`."
		)
		console.error("https://docs.xtcy.dev/install/surrealdb/")
		process.exit(1)
	}
}
