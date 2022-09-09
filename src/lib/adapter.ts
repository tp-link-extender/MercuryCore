import type { PrismaClient } from "@prisma/client"
import pkg from "@prisma/client/runtime/index.js"
import type { Adapter } from "lucia-sveltekit/types"
import { Error, adapterGetUpdateData } from "lucia-sveltekit"

// Do yourself a favour and don't try to understand this code.

const adapter = (prisma: PrismaClient): Adapter => {
	return {
		getUserByRefreshToken: async (refreshToken: string) => {
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
				console.error(e)
				if (!(e instanceof pkg.PrismaClientKnownRequestError)) throw new Error("UNKNOWN_ERROR")
				throw new Error("DATABASE_FETCH_FAILED")
			}
		},
		getUserByIdentifierToken: async (identifierToken: string) => {
			try {
				const data = await prisma.user.findMany({
					where: {
						idToken: identifierToken,
					},
				})
				return data[0] as any | null
			} catch (e) {
				console.error(e)
				if (!(e instanceof pkg.PrismaClientKnownRequestError)) throw new Error("UNKNOWN_ERROR")
				throw new Error("DATABASE_FETCH_FAILED")
			}
		},
		setUser: async (
			username: string,
			data: {
				identifier_token: string
				hashed_password: string | null
				user_data: Record<string, any>
			}
		) => {
			try {
				await prisma.user.create({
					data: {
						username: data.user_data.username,
						displayname: data.user_data.username,
						idToken: data.identifier_token,
						password: data.hashed_password,
						image: data.user_data.image,
					},
				})
				return
			} catch (e) {
				console.error(e)
				if (!(e instanceof pkg.PrismaClientKnownRequestError)) throw new Error("UNKNOWN_ERROR")
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
			throw new Error("DATABASE_UPDATE_FAILED") // no
		},
		setRefreshToken: async (refreshToken: string, username: string) => {
			try {
				await prisma.refreshToken.create({
					data: {
						token: refreshToken,
						userUsername: username,
					},
				})
				return
			} catch (e) {
				console.error(e)
				if (!(e instanceof pkg.PrismaClientKnownRequestError)) throw new Error("UNKNOWN_ERROR")
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
				console.error(e)
				if (!(e instanceof pkg.PrismaClientKnownRequestError)) throw new Error("UNKNOWN_ERROR")
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
				console.error(e)
				if (!(e instanceof pkg.PrismaClientKnownRequestError)) throw new Error("UNKNOWN_ERROR")
				throw new Error("DATABASE_UPDATE_FAILED")
			}
		},
		getUserById: async (username: string) => {
			try {
				const data = await prisma.user.findUnique({
					where: {
						username: username,
					},
				})
				return data as any | null
			} catch (e) {
				console.error(e)
				if (!(e instanceof pkg.PrismaClientKnownRequestError)) throw new Error("UNKNOWN_ERROR")
				throw new Error("DATABASE_FETCH_FAILED")
			}
		},
		updateUser: async (username, newData) => {
			const partialData = adapterGetUpdateData(newData)
			try {
				const data = await prisma.user.update({
					data: partialData,
					where: {
						username: username,
					},
				})
				return data
			} catch (e) {
				console.error(e)
				if (!(e instanceof pkg.PrismaClientKnownRequestError)) throw new Error("UNKNOWN_ERROR")
				if (e.code === "P2025") throw new Error("AUTH_INVALID_USER_ID")
				throw new Error("DATABASE_FETCH_FAILED")
			}
		},
	}
}

export default adapter
