// Initialising Lucia, the authentication library

import { dev } from "$app/environment"
import { prisma } from "$lib/server/prisma"
import lucia from "lucia-auth"
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
