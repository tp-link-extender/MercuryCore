// Config file for pm2, a process manager that lets the Site run as a background process
// https://pm2.io/

module.exports = {
	apps: [
		{
			name: "Mercury",
			script: "bun",
			intperpreter: "none",
			args: "./build",
		},
	],
}
