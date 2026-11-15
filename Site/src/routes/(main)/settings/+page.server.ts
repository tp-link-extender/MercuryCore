import config from "$lib/server/config"

const themeNames = config.Themes.map(t => t.Name)

export const load = () => ({
	themes: themeNames,
})
