// Config file for pm2, a process manager that lets the website server run as a background process
// https://pm2.io/

module.exports = {
	apps: [
		{
			name: "Mercury",
			script: "build",
			intperpreter: "~/.bun/bin/bun",
		},
	],
}
