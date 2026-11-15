let started = false

function startSurreal(rootPassword: string): void {
	if (started) return
	started = true
	console.log("Starting SurrealDB...")

	try {
		const proc = Bun.spawn(
			[
				"surreal",
				"start",
				"--bind=127.0.0.1:8000",
				"surrealkv://data/surreal",
			],
			{
				cwd: "..",
				// Passed in the environment rather than as arguments, which other users can see in `ps`. Only used if the store has no root user yet.
				env: {
					...process.env,
					SURREAL_PASS: rootPassword,
					SURREAL_USER: "root",
				},
				stderr: "pipe",
				stdout: "pipe",
			}
		)

		process.on("exit", () => {
			console.log("Shutting down SurrealDB...")
			proc.kill()
		})

		void proc.exited.then(async () => {
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
		console.error("https://docs.mercs.dev/install/surrealdb/")
		process.exit(1)
	}
}

export default startSurreal
