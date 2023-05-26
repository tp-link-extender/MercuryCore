/** @type { import("@inlang/core/config").DefineConfig } */
export async function defineConfig(env) {
	const { default: sdkPlugin } = await env.$import(
		"https://cdn.jsdelivr.net/npm/@inlang/sdk-js-plugin@0.6.1/dist/index.js"
	)
	const { default: pluginYaml } = await env.$import(
		"https://cdn.jsdelivr.net/gh/felixhaeberle/inlang-plugin-yaml/dist/index.js"
	)

	return {
		referenceLanguage: "en",
		plugins: [
			pluginYaml({
				pathPattern: "./i18n/{language}.yml",
			}),
			// ... other plugins e.g. to read and write Resources
			// see https://github.com/inlang/ecosystem#resources
			sdkPlugin({
				languageNegotiation: {
					strategies: [{ type: "localStorage" }],
				},
			}),
		],
	}
}
