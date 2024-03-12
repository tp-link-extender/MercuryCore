import { SignData } from "$lib/server/sign"
import fs from "node:fs"

export const GET = () =>
	new Response(
		SignData(
			fs
				.readFileSync("corescripts/processed/visit.lua", "utf-8")
				.replaceAll("_PLACE_ID", "0")
				.replaceAll("_GUEST_NUMBER", "9042")
		)
	)
