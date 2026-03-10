const types = Object.freeze(["friends", "followers", "following"])
export const match: import("@sveltejs/kit").ParamMatcher = param =>
	types.includes(param)
