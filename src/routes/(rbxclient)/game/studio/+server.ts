import { SignData } from "$lib/server/sign"
import fs from "fs"

export const GET = async () =>
	new Response(
		SignData(fs.readFileSync(`corescripts/processed/studio.lua`, "utf-8"))
	)
