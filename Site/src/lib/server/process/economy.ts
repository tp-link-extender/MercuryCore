const cwd = "../Economy"

let started = false

export default async () => {
	if (started) return
	started = true
	console.log("Starting Economy service...")

	const exists = await Bun.file(`${cwd}/Economy`).exists()

	if (!exists) {
		console.error("Attempting to build the Economy service...")
		await Bun.spawn(["go", "build"], { cwd }).exited
	}

	const name = process.platform === "win32" ? "Economy.exe" : "Economy"
	const proc = Bun.spawn([name], {
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
