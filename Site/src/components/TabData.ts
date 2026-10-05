/**
 * Creates an object to provide data to the TabNav and Tab components.
 * @param url The current URL, usually obtained by `data.url`
 * @param tabs An array of tab names
 * @param icons An array of icon classes, corresponding to the tabs
 * @param name The name of the query parameter to use for the tab
 * @param groups Tabs to group under a dropdown tab, whose trigger
 * shows up in place of the first tab in each group
 * @returns An object to provide data to the TabNav and Tab components
 * @example
 * let tabData = TabData(url, ["tab1", "tab2"], ["fa-user", "fa-gem"])
 * @example
 * let tabData = TabData(url, ["tab1", "tab2", "tab3"], undefined, "tab", [
 *     { name: "Extras", tabs: ["tab2", "tab3"] },
 * ])
 */
export default (
	url: string,
	tabs: string[],
	icons?: string[],
	name = "tab",
	groups?: { name: string; tabs: string[] }[]
) => ({
	name,
	tabs,
	currentTab: new URL(url).searchParams.get(name || "tab") || tabs[0],
	url,
	icons,
	groups,
	num: 0,
})
