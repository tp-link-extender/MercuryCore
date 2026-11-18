// Contains various api methods that cannot be accessed in a page context,
// usually because they are requested from a component.

import { error } from "@sveltejs/kit"

const msg = Buffer.from("ZHVtYiBuKiBkZXRlY3RlZA==", "base64").toString()

export function load() {
	error(403, msg)
}
