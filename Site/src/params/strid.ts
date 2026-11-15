import type { ParamMatcher } from "@sveltejs/kit"
import { idRegex } from "$lib/paramTests"

// bind() black magic
export const match: ParamMatcher = idRegex.test.bind(idRegex)
