// Contains types for Lucia to prevent TypeScript
// from complaining about missing types.

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
			currency: number
			currencyCollected: string
			created: string
			email: string
			hashedPassword: string
			lastOnline: string
			permissionLevel: number
			css: string
			realtimeToken: string
			realtimeExpiry: number
			realtimeHash: number
			// theme: "standard" | "darken" | "storm" | "solar"
		} & BasicUser
	}
}

declare global {
	declare type BasicUser = {
		number: number
		status: "Playing" | "Online" | "Offline"
		username: string
	}

	declare module "*.surql" {
		const value: string
		export default value
	}

	namespace App {
		interface Locals {
			user: import("lucia").User | null
			session: import("lucia").Session | null
		}
		interface PageState {
			openPost?: import("./routes/(main)/forum/[category]/[post]/$types").PageData
			openPlace?: import("./routes/(main)/place/[id]/[name]/$types").PageData
		}
	}
}

export type {}
