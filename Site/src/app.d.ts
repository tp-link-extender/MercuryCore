import type { AvailableLanguageTag } from "$lib/paraglide/runtime"
import type { ParaglideLocals } from "@inlang/paraglide-sveltekit"
//  Prevents TypeScript from complaining about missing types.

/// <reference types="lucia" />
/// <reference types="@types/bun" />

declare namespace svelteHTML {
	import type { AttributifyAttributes } from "@unocss/preset-attributify"

	type HTMLAttributes = AttributifyAttributes
}

declare module "lucia" {
	interface Register {
		Lucia: typeof import("$lib/server/lucia").auth
		DatabaseUserAttributes: {
			id: string
			bio: {
				text: string
				updated: string
			}[]
			bodyColours: {
				Head: number
				LeftArm: number
				LeftLeg: number
				RightArm: number
				RightLeg: number
				Torso: number
			}
			created: string
			email: string
			lastOnline: string
			permissionLevel: number
			css: string
			theme: number
		} & BasicUser
	}
}

declare global {
	/**
	 * All that's needed to show a user's information/link to their profile.
	 */
	declare type BasicUser = {
		status: "Playing" | "Online" | "Offline"
		username: string
	}

	declare module "*.surql" {
		const value: string
		export default value
	}

	namespace App {
		interface Locals {
			paraglide: ParaglideLocals<AvailableLanguageTag>

			user: import("lucia").User | null
			session: import("lucia").Session | null
		}
	}
}

export type {}
