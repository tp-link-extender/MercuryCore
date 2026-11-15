import type { ParamMatcher } from "@sveltejs/kit"
import { assetRegex } from "$lib/paramTests"

// bind() black magic
export const match: ParamMatcher = assetRegex.test.bind(assetRegex)
