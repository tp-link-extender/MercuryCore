import { error } from "@sveltejs/kit"
import config, { type OptionalPage } from "$lib/server/config"

// This is the kind of thing that hooks don't work well for
const exclude = (page: OptionalPage) => {
	if (!config.Pages.includes(page)) error(404, "Not Found")
}

export default exclude
