import config, { type OptionalPage } from "$lib/server/config"
import { error } from "@sveltejs/kit"

// This is the kind of thing that hooks don't work well for
export default (page: OptionalPage) => {
	if (!config.Pages.includes(page as (typeof config.Pages)[number]))
		error(404, "Not Found")
}
