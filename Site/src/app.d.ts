//  Prevents TypeScript from complaining about missing types.

/// <reference types="@types/bun" />

import type { AttributifyAttributes } from "@unocss/preset-attributify"

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
		description: {
			text: string
			updated: Date
		}[]
		email: string
		id: string
		lastOnline: Date
		permissionLevel: number
		theme: number
	}

	namespace App {
		interface Locals {
			session: string | null
			user: User | null
		}
	}
}
