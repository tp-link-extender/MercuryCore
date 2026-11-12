import type { ParamMatcher } from "@sveltejs/kit"

// 32 random bytes encoded as base64url, see lib/server/recoveryToken.ts
const recoveryTokenRegex = /^[\w-]{43}$/

export const match: ParamMatcher =
	recoveryTokenRegex.test.bind(recoveryTokenRegex)
