import { dev } from "$app/environment"
import { prisma } from "$lib/server/prisma"
import lucia from "lucia-auth"
import aPrisma from "@lucia-auth/adapter-prisma"

export const auth = lucia({
	adapter: aPrisma(prisma),
	env: dev ? "DEV" : "PROD",
	transformUserData: (data: any) => ({
		userId: data.id,
		number: data.number,
		bio: data.bio,
		theme: data.theme,
		email: data.email,
		username: data.username,
		displayname: data.displayname,
		image: data.image,
		currency: data.currency,
		currencyCollected: data.currencyCollected,
		permissionLevel: data.permissionLevel,
	}),
	generateCustomUserId: () => crypto.randomUUID(),
})

export type Auth = typeof auth
