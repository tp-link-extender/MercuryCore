const cwd = "../Economy"
const name = `Economy${process.platform === "win32" ? ".exe" : ""}`
const path = `${cwd}/${name}`

let started = false

export default async () => {
	if (started) return
	started = true

	if (!(await Bun.file(path).exists())) {
		console.log(
			"Economy service does not exist. Attempting to build it with Go..."
		)
		try {
			await Bun.spawn(["go", "build"], { cwd }).exited
		} catch {
			console.error(
				"The attempt to  automatically build the Economy service failed. Please build the service automatically, by navigating to the Economy folder and running `go build`, or make sure Go is installed and accessible as `go`."
			)
			console.error("https://docs.xtcy.dev/install/go/")
			process.exit(1)
		}
	}

	console.log(`Starting Economy service (${path})...`)
	const proc = Bun.spawn([`./${name}`], {
		cwd,
		stdout: "pipe",
		stderr: "pipe",
	})

	process.on("exit", () => {
		console.log("Shutting down Economy service...")
		proc.kill()
	})

	proc.exited.then(async () => {
		console.error("Economy service process exited unexpectedly.")
		const r = await proc.stdout.getReader().read() // maybe stderr idk, I don't think the service uses it tho
		const logs = new TextDecoder().decode(r.value)
		console.log(logs.split("\n").slice(-10).join("\n"))
		process.exit(1)
	})
}
