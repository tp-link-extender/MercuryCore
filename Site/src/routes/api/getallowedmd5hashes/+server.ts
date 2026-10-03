import { json } from "@sveltejs/kit"

export const GET = () => json({ data: ["1724a4508ce7db4830d0611f9d877de9", "a829758509fcc8fafb6fc2a394ddbfd8"] }) // TODO: make configurable from mercury.core.ts
