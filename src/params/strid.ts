import { idRegex } from "$lib/paramTests"

// bind() black magic
export const match: import("@sveltejs/kit").ParamMatcher =
	idRegex.test.bind(idRegex)
