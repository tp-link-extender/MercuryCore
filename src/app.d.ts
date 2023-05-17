// Contains types for Lucia to prevent TypeScript
// from complaining about missing types.

/// <reference types="lucia-auth" />
declare namespace Lucia {
	type Auth = import("$lib/server/lucia").Auth
	type UserAttributes = {
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
}

/// <reference types="@sveltejs/kit" />
declare namespace App {
	interface Locals {
		setSession: (session: Session | null) => void
		validate: () => Promise<Session | null>
		validateUser: () => Promise<
			| {
					user: null
					session: null
			  }
			| {
					user: User
					session: Session
			  }
		>
		getCookie: () => Cookie | null
	}
}
