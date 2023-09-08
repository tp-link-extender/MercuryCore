import { authorise } from "$lib/server/lucia"

// Most pages on the site require a user to be logged in.
export const load = ({ locals }) => authorise(locals)
