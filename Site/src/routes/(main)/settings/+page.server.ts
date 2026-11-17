import config from "#lib/server/config.ts"

const themeNames = config.Themes.map(t => t.Name)

export const load = () => ({
	themes: themeNames,
})
