/// <reference types="lucia-auth" />
declare namespace Lucia {
	type Auth = import("$lib/server/lucia").Auth
	type UserAttributes = {}
	interface UserAttributes {}
}

/// <reference types="@sveltejs/kit" />
declare namespace App {
	interface Locals {
		getSession: import("@lucia-auth/sveltekit").GetSession
		getSessionUser: import("@lucia-auth/sveltekit").GetSessionUser
		setSession: import("@lucia-auth/sveltekit").SetSession
	}
}
