module.exports = {
	apps: [
		{
			name: "Mercury",
			script: "build/index.js",
			node_args: "-r dotenv/config",
		},
	],
}
