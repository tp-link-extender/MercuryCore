import Tab from "./Tab.svelte"
import TabNav from "../../routes/tabs/TabNav.svelte"

export { Tab, TabNav }
export const TabData = (tabs: string[], url: string, name = "tab") => ({
	name,
	tabs,
	currentTab: new URL(url).searchParams.get(name),
})
