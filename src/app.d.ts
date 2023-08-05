// Contains types for Lucia to prevent TypeScript
// from complaining about missing types.

/// <reference types="lucia" />

declare global {
	namespace App {
		interface Locals {
			auth: import("lucia").AuthRequest
		}
	}
	namespace Lucia {
		type Auth = typeof import("$lib/server/lucia").auth
		type DatabaseUserAttributes = {
			// id is defined in Lucia
			number: number
			bio: string
			email: string
			username: string
			currency: number
			currencyCollected: Date
			permissionLevel: number
			created: Date
			bodyColours: {
				Head: number
				Torso: number
				LeftArm: number
				RightArm: number
				LeftLeg: number
				RightLeg: number
			}
			theme: string
		}
		type DatabaseSessionAttributes = {}
	}

	// sveltekit-autoimport types

	declare const fade: typeof import("$lib/fade").default

	declare const AdminLink: typeof import("$lib/components/AdminLink.svelte").default
	declare const Asset: typeof import("$lib/components/Asset.svelte").default
	declare const Cube: typeof import("$lib/components/Cube.svelte").default
	declare const Cubes: typeof import("$lib/components/Cubes.svelte").default
	declare const DeleteButton: typeof import("$lib/components/DeleteButton.svelte").default
	declare const Footer: typeof import("$lib/components/Footer.svelte").default
	declare const ForumPost: typeof import("$lib/components/ForumPost.svelte").default
	declare const ForumReply: typeof import("$lib/components/ForumReply.svelte").default
	declare const Group: typeof import("$lib/components/Group.svelte").default
	declare const Head: typeof import("$lib/components/Head.svelte").default
	declare const Modal: typeof import("$lib/components/Modal.svelte").default
	declare const Moon: typeof import("$lib/components/Moon.svelte").default
	declare const Navbar: typeof import("$lib/components/Navbar.svelte").default
	declare const Pagepart: typeof import("$lib/components/Pagepart.svelte").default
	declare const Place: typeof import("$lib/components/Place.svelte").default
	declare const PlaceCard: typeof import("$lib/components/PlaceCard.svelte").default
	declare const ReportButton: typeof import("$lib/components/ReportButton.svelte").default
	declare const Tab: typeof import("$lib/components/Tab.svelte").default
	declare const TabData: typeof import("$lib/components/TabData").default
	declare const TabNav: typeof import("$lib/components/TabNav.svelte").default
	declare const UserCard: typeof import("$lib/components/UserCard.svelte").default

	declare const { onMount }: typeof import("svelte")
	declare const { writable }: typeof import("svelte/store")
	declare const { enhance, deserialize }: typeof import("$app/forms")
}

export {}
