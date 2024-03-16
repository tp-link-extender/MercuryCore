// Route matchers! Knew about these for a while but only got around to using them now.
// No need for regexes in the routes anymore lelel
export const match: import("@sveltejs/kit").ParamMatcher = param =>
	/^\d+$/.test(param)
