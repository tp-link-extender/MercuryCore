import { PrismaClient } from "@prisma/client"
import lucia from "lucia-sveltekit"
import prisma from "$lib/adapter"
import { dev } from "$app/environment"

export const auth = lucia({
	adapter: prisma(new PrismaClient()),
	secret: "bruhmomentbruhmomentbruhmomentbruhmoment",
	env: dev ? "DEV" : "PROD",
})
