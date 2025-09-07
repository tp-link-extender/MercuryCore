import { assetRegex } from "$lib/paramTests"

// bind() black magic
export const match: import("@sveltejs/kit").ParamMatcher =
	assetRegex.test.bind(assetRegex)
