import { dev } from "$app/environment"
import lucia from "lucia-auth"
import redis from "./redis-adapter"
import prisma from "@lucia-auth/adapter-prisma"
import { PrismaClient } from "@prisma/client"
import { createClient } from "redis"

export const sessionClient = createClient({ url: "redis://localhost:6479" })
await sessionClient.connect()

export const auth = lucia({
	adapter: {
		user: prisma(new PrismaClient()),
		session: redis({
			session: sessionClient,
			userSessions: sessionClient,
		}),
	},

	env: dev ? "DEV" : "PROD",
	transformUserData: (userData: any) => {
		return {
			userId: userData.id,
			username: userData.username,
			displayname: userData.displayname,
			image: userData.image,
		}
	},
})

export type Auth = typeof auth
