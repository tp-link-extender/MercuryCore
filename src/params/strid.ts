export const match: import("@sveltejs/kit").ParamMatcher = param =>
	/^[0-9a-z]+$/.test(param)
