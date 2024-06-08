import { idTest } from "$lib/server/paramTests"

export const match: import("@sveltejs/kit").ParamMatcher = param =>
	idTest(param)
