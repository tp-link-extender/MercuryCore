// Initialising Lucia, the authentication library

import { dev } from "$app/environment"
import { prisma } from "$lib/server/prisma"
import { redirect, error } from "@sveltejs/kit"
import lucia from "lucia-auth"
import type { Session, User } from "lucia-auth"
import prismaAdapter from "@lucia-auth/adapter-prisma"

export const auth = lucia({
	adapter: prismaAdapter(prisma),
	env: dev ? "DEV" : "PROD",
	transformUserData: (data: any) => ({
		// This is the data that will be available after calling
		// getUser() in a +page.svelte or +layout.svelte file.
		userId: data.id,
		number: data.number,
		bio: data.bio,
		email: data.email,
		username: data.username,
		image: data.image,
		currency: data.currency,
		currencyCollected: data.currencyCollected,
		permissionLevel: data.permissionLevel,
		accountCreated: data.created,
		bodyColours: data.bodyColours,
		moderation: data.moderationActionsReceived,
		theme: data.theme,
		animationSettings: data.animationSettings,
	}),
	generateCustomUserId: () => crypto.randomUUID(),
})

export type Auth = typeof auth

export async function authorise(promise: () => Promise<Session | null>) {
	const session = await promise()
	if (!session) throw redirect(302, "/login")
	return session
}

export async function authoriseUser(
	promise: () => Promise<
		| {
				session: Session
				user: User
		  }
		| {
				session: null
				user: null
		  }
	>
) {
	const { session, user } = await promise()
	if (!session) throw redirect(302, "/login")
	return { session, user }
}

export async function authoriseAdmin(locals: any) {
	const { session, user } = await locals.validateUser()

	if (!session || user.permissionLevel < 5) throw error(451, Buffer.from("RHVtYiBuaWdnYSBkZXRlY3RlZA", "base64").toString("ascii"))
}

export async function authoriseMod(locals: any) {
	const { session, user } = await locals.validateUser()

	if (!session || user.permissionLevel < 4) throw error(451, Buffer.from("RHVtYiBuaWdnYSBkZXRlY3RlZA", "base64").toString("ascii"))
}

export async function authoriseAllAdmin(locals: any) {
	const { session, user } = await locals.validateUser()

	if (!session || user.permissionLevel < 3) throw error(451, Buffer.from("RHVtYiBuaWdnYSBkZXRlY3RlZA", "base64").toString("ascii"))
}
