import { dev } from "$app/environment"
import { prisma } from "$lib/server/prisma"
import lucia from "lucia-auth"
import { createClient } from "redis"
import aRedis from "@lucia-auth/adapter-session-redis"
import aPrisma from "@lucia-auth/adapter-prisma"

const session = createClient({ url: "redis://localhost:6479" })
const userSession = createClient({ url: "redis://localhost:6479" })
session.connect()
userSession.connect()

export const auth = lucia({
	adapter: {
		user: aPrisma(prisma),
		session: aRedis({
			session,
			userSession,
		}),
	},
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
