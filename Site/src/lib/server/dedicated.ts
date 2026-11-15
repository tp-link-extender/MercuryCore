import config from "$lib/server/config"

/** Whether a place runs on a dedicated server, given the site's hosting mode and the place's own setting. */
export const usesDedicated = (dedicated: boolean): boolean =>
	config.Gameservers.Hosting === "Both"
		? dedicated
		: config.Gameservers.Hosting === "Dedicated"
