// Route matchers! Knew about these for a while but only got around to using them now.
// No need for regexes in the routes anymore lelel

import { defineParams } from "@sveltejs/kit/params"
import { assetRegex, idRegex, intRegex } from "#lib/paramTests.ts"

// 32 random bytes encoded as base64url, see lib/server/recoveryToken.ts
const recoveryTokenRegex = /^[\w-]{43}$/
const taskIdRegex = /^[\d\w]+$/
const types = Object.freeze(["friends", "followers", "following"])

// A matcher returns the param unchanged if it matches, or undefined if it doesn't
const matchRegex = (regex: RegExp) => (param: string) =>
	regex.test(param) ? param : undefined

export const params = defineParams({
	asset: matchRegex(assetRegex),
	f: (param: string) => (types.includes(param) ? param : undefined),
	integer: matchRegex(intRegex),
	recoverytoken: matchRegex(recoveryTokenRegex),
	strid: matchRegex(idRegex),
	taskid: matchRegex(taskIdRegex),
})
