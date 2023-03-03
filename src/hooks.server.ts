// "'Hooks' are app-wide functions you declare that SvelteKit will call in response to
// specific events, giving you fine-grained control over the framework's behaviour."

// See https://kit.svelte.dev/docs/hooks/ for more info.

import { auth } from "$lib/server/lucia"
import { handleHooks } from "@lucia-auth/sveltekit"

export const handle = handleHooks(auth) // Ran every time a request is made
