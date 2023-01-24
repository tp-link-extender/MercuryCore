import { dev } from "$app/environment"
import { prisma } from "$lib/server/prisma"
import lucia from "lucia-auth"
import aPrisma from "@lucia-auth/adapter-prisma"

export const auth = lucia({
	adapter: aPrisma(prisma),
	env: dev ? "DEV" : "PROD",
	transformUserData: (userData: any) => {
		return {
			userId: userData.id,
			username: userData.username,
			displayname: userData.displayname,
			image: userData.image,
			currency: userData.currency,
		}
	},
})

export type Auth = typeof auth
