import { PrismaClient } from "@prisma/client"
import lucia from "lucia-sveltekit"
import prisma from "$lib/adapter"

import { dev } from "$app/env"

export const auth = lucia({
	adapter: prisma(new PrismaClient()),
	env: dev ? "DEV" : "PROD",
	secret: "bruhmoment",
})
