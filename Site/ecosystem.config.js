// Config file for pm2, a process manager that lets the Site run as a background process
// https://pm2.io/

module.exports = {
	apps: [
		{
			args: "./build",
			env: {
				HOST: "0.0.0.0",
			},
			intperpreter: "none",
			name: "Mercury",
			script: "bun",
		},
	],
}
