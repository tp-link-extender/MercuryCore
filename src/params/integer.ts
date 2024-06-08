// Route matchers! Knew about these for a while but only got around to using them now.
// No need for regexes in the routes anymore lelel

import { intTest } from "$lib/server/paramTests"

export const match: import("@sveltejs/kit").ParamMatcher = intTest
