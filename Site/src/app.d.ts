//  Prevents TypeScript from complaining about missing types.

/// <reference types="@types/bun" />

import type { AttributifyAttributes } from "@unocss/preset-attributify"
import type { RemoteFormInput as RFI } from "$app/server"

declare global {
	namespace svelteHTML {
		type HTMLAttributes = AttributifyAttributes
	}

	/**
	 * All that's needed to show a user's information/link to their profile.
	 */
	interface BasicUser {
		status: "Playing" | "Online" | "Offline"
		username: string
	}

	/**
	 * The user of the current session, as loaded on every request. Pages that need more about the user load it themselves.
	 */
	interface SessionUser extends BasicUser {
		css: string
		id: string
		permissionLevel: number
		theme: number
	}

	// just useful in form component generics
	// can't export straight from the package right here, it'll cause the other types (such as Locals) to not be global
	type RemoteFormInput = RFI

	namespace App {
		interface Locals {
			// Whether the user has an active moderation, checked once per request in hooks.server.ts
			moderated: boolean
			session: string | null
			user: SessionUser | null
		}
	}
}
