const taskIdRegex = /^[\d\w]+$/

export const match: import("@sveltejs/kit").ParamMatcher =
	taskIdRegex.test.bind(taskIdRegex)
