// Config file for pm2, a process manager that lets the Site run as a background process
// https://pm2.io/

module.exports = {
	apps: [
		{
			args: "./build",
			env: {
				// Caddy puts the client's address last in X-Forwarded-For, which is what ratelimits are keyed on
				ADDRESS_HEADER: "X-Forwarded-For",
				// Only Caddy should reach the Site, so don't listen on public interfaces
				HOST: "127.0.0.1",
				XFF_DEPTH: "1",
			},
			intperpreter: "none",
			name: "Mercury",
			script: "bun",
		},
	],
}
