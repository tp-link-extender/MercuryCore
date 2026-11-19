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

	interface User extends BasicUser {
		bodyColours: {
			Head: number
			LeftArm: number
			LeftLeg: number
			RightArm: number
			RightLeg: number
			Torso: number
		}
		created: string
		css: string
		// The current text of the description, or null if there isn't one
		description: string | null
		email: string
		id: string
		lastOnline: Date
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
			user: User | null
		}
	}
}
