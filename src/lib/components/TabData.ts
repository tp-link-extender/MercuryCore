/**
 * Creates an object to provide data to the TabNav and Tab components.
 * @param url The current URL, usually obtained by `data.url`
 * @param tabs An array of tab names
 * @param icons An array of fa icon classes, corresponding to the tabs
 * @param name The name of the query parameter to use for the tab
 * @returns An object to provide data to the TabNav and Tab components
 * @example
 * let tabData = TabData(url, ["tab1", "tab2"], ["fa fa-1", "fa fa-2"])
 */
export default (
	url: string,
	tabs: string[],
	icons?: string[],
	name = "tab",
) => ({
	name,
	tabs,
	currentTab: new URL(url).searchParams.get(name || "tab") || tabs[0],
	url,
	icons,
	num: 0,
})
