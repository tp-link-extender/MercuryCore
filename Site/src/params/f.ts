import type { ParamMatcher } from "@sveltejs/kit"

const types = Object.freeze(["friends", "followers", "following"])
export const match: ParamMatcher = param => types.includes(param)
