// Contains types for Lucia to prevent TypeScript
// from complaining about missing types.

/// <reference types="lucia-auth" />
declare namespace Lucia {
	type Auth = import("$lib/server/lucia").Auth
	type UserAttributes = {}
}

/// <reference types="@sveltejs/kit" />
declare namespace App {
	type Locals = import("lucia-auth").AuthRequest;
}
