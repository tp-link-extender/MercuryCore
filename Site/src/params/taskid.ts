import type { ParamMatcher } from "@sveltejs/kit"

const taskIdRegex = /^[\d\w]+$/

export const match: ParamMatcher = taskIdRegex.test.bind(taskIdRegex)
