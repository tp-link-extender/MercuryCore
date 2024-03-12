import { SignData } from "$lib/server/sign"
import fs from "node:fs"

export const GET = () =>
	new Response(
		SignData(fs.readFileSync("corescripts/processed/studio.lua", "utf-8"))
	)
