// Contains types for Lucia to prevent TypeScript
// from complaining about missing types.

/// <reference types="lucia-auth" />
declare namespace Lucia {
	type Auth = import("$lib/server/lucia").Auth
	type UserAttributes = {}
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
