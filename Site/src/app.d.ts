//  Prevents TypeScript from complaining about missing types.

/// <reference types="@types/bun" />

declare namespace svelteHTML {
	import type { AttributifyAttributes } from "@unocss/preset-attributify"

	type HTMLAttributes = AttributifyAttributes
}

declare global {
	/**
	 * All that's needed to show a user's information/link to their profile.
	 */
	declare type BasicUser = {
		status: "Playing" | "Online" | "Offline"
		username: string
	}

	declare interface User extends BasicUser {
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

	declare module "*.surql" {
		const value: string
		export default value
	}

	namespace App {
		interface Locals {
			session: string | null
			user: User | null
		}
	}
}

export type {}
