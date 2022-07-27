import type { PrismaClient } from "@prisma/client"
import pkg from "@prisma/client/runtime/index.js"
import type { Adapter } from "lucia-sveltekit/types"
import { Error } from "lucia-sveltekit"

const adapter = (prisma: PrismaClient): Adapter => {
	return {
		getUserFromRefreshToken: async (refreshToken: string) => {
			try {
				const username = await prisma.refreshToken.findUnique({
					where: {
						token: refreshToken,
					},
					select: {
						userUsername: true,
					},
				})
				return username || (null as any | null)
			} catch (e) {
				if (!(e instanceof pkg.PrismaClientKnownRequestError)) throw new Error("UNKNOWN_ERROR")
				throw new Error("DATABASE_FETCH_FAILED")
			}
		},
		getUserFromIdentifierToken: async (identifierToken: string) => {
			try {
				const data = await prisma.user.findMany({
					where: {
						idToken: identifierToken,
					},
				})
				return data[0] as any | null
			} catch (e) {
				if (!(e instanceof pkg.PrismaClientKnownRequestError)) throw new Error("UNKNOWN_ERROR")
				console.error(e)
				throw new Error("DATABASE_FETCH_FAILED")
			}
		},
		createUser: async (
			username: string,
			data: {
				identifier_token: string
				hashed_password: string | null
				user_data: Record<string, any>
			}
		) => {
			try {
				const user = await prisma.user.create({
					data: {
						username: username,
						idToken: data.identifier_token,
						password: data.hashed_password,
					},
				})
				return
			} catch (e) {
				if (!(e instanceof pkg.PrismaClientKnownRequestError)) throw new Error("UNKNOWN_ERROR")
				console.error(e)
				if (e.code === "P2002" && e.message.includes("identifier_token")) {
					throw new Error("AUTH_DUPLICATE_IDENTIFIER_TOKEN")
				}
				if (e.code === "P2002") {
					throw new Error("AUTH_DUPLICATE_USER_DATA")
				}
				throw new Error("DATABASE_UPDATE_FAILED")
			}
		},
		deleteUser: async (username: string) => {
			// no

			// try {
			// 	await prisma.user.deleteMany({
			// 		where: {
			// 			username: username,
			// 		},
			// 	})
			// 	return
			// } catch (e) {
			// 	if (!(e instanceof pkg.PrismaClientKnownRequestError)) throw new Error("UNKNOWN_ERROR")
			// 	console.error(e)
			throw new Error("DATABASE_UPDATE_FAILED")
			// }
		},
		saveRefreshToken: async (refreshToken: string, username: string) => {
			console.log(refreshToken)
			try {
				await prisma.refreshToken.create({
					data: {
						token: refreshToken,
						userUsername: username,
					},
				})
				return
			} catch (e) {
				if (!(e instanceof pkg.PrismaClientKnownRequestError)) throw new Error("UNKNOWN_ERROR")
				console.error(e)
				throw new Error("DATABASE_UPDATE_FAILED")
			}
		},
		deleteRefreshToken: async (refreshToken: string) => {
			try {
				await prisma.refreshToken.deleteMany({
					where: {
						token: refreshToken,
					},
				})
				return
			} catch (e) {
				if (!(e instanceof pkg.PrismaClientKnownRequestError)) throw new Error("UNKNOWN_ERROR")
				console.error(e)
				throw new Error("DATABASE_UPDATE_FAILED")
			}
		},
		deleteUserRefreshTokens: async (username: string) => {
			try {
				await prisma.refreshToken.deleteMany({
					where: {
						userUsername: username,
					},
				})
				return
			} catch (e) {
				if (!(e instanceof pkg.PrismaClientKnownRequestError)) throw new Error("UNKNOWN_ERROR")
				console.error(e)
				throw new Error("DATABASE_UPDATE_FAILED")
			}
		},
	}
}

export default adapter
