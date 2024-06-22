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

	// sveltekit-autoimport types

	declare const fade: typeof import("$lib/fade").default

	declare const Accordion: typeof import("$lib/components/Accordion.svelte").default
	declare const AccordionItem: typeof import("$lib/components/AccordionItem.svelte").default
	declare const AdminLink: typeof import("$lib/components/AdminLink.svelte").default
	declare const Asset: typeof import("$lib/components/Asset.svelte").default
	declare const Breadcrumbs: typeof import("$lib/components/Breadcrumbs.svelte").default
	declare const DeleteButton: typeof import("$lib/components/DeleteButton.svelte").default
	declare const Footer: typeof import("$lib/components/Footer.svelte").default
	declare const ForumReply: typeof import("$lib/components/ForumReply.svelte").default
	declare const Group: typeof import("$lib/components/Group.svelte").default
	declare const Head: typeof import("$lib/components/Head.svelte").default
	declare const Modal: typeof import("$lib/components/Modal.svelte").default
	declare const Moon: typeof import("$lib/components/Moon.svelte").default
	declare const Navbar: typeof import("$lib/components/Navbar.svelte").default
	declare const NoScript: typeof import("$lib/components/NoScript.svelte").default
	declare const PinButton: typeof import("$lib/components/PinButton.svelte").default
	declare const Place: typeof import("$lib/components/Place.svelte").default
	declare const PostReply: typeof import("$lib/components/PostReply.svelte").default
	declare const ReportButton: typeof import("$lib/components/ReportButton.svelte").default
	declare const SidebarShell: typeof import("$lib/components/SidebarShell.svelte").default
	declare const Tab: typeof import("$lib/components/Tab.svelte").default
	declare const TabData: typeof import("$lib/components/TabData").default
	declare const TabNav: typeof import("$lib/components/TabNav.svelte").default
	declare const User: typeof import("$lib/components/User.svelte").default
	declare const UserCard: typeof import("$lib/components/UserCard.svelte").default
	declare const YesScript: typeof import("$lib/components/YesScript.svelte").default

	declare const Codearea: typeof import("$lib/components/forms/Codearea.svelte").default
	declare const Form: typeof import("$lib/components/forms/Form.svelte").default
	declare const Input: typeof import("$lib/components/forms/Input.svelte").default
	declare const Select: typeof import("$lib/components/forms/Select.svelte").default
	declare const Textarea: typeof import("$lib/components/forms/Textarea.svelte").default

	declare const { onMount, onDestroy }: typeof import("svelte")
	declare const { writable }: typeof import("svelte/store")
	declare const { enhance, deserialize }: typeof import("$app/forms")
}

export type {}
