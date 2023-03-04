import type { Actions } from "./$types"
import { authoriseUser } from "$lib/server/lucia"
import { prisma, transaction } from "$lib/server/prisma"
import { fail, redirect } from "@sveltejs/kit"

export const actions: Actions = {
	default: async ({ locals, request }) => {
		return fail(400, { msg: "Games have been momentarily disabled due to client testing" }) // Games disabled during testing

		const user = (await authoriseUser(locals.validateUser())).user

		const data = await request.formData()
<<<<<<< HEAD
		const name = data.get("name") as string
		const description = data.get("description") as string
		const serverIP = data.get("serverIP") as string
		const serverPort = parseInt(data.get("serverPort") as string)
		const maxPlayers = parseInt(data.get("maxPlayers") as string)
		const privateServer = !!data.get("privateServer")

		console.log(name, description, serverIP, serverPort, maxPlayers, privateServer)

		if (!name || !description || !serverIP || !serverPort || !maxPlayers) return fail(400, { msg: "Missing fields" })
		if (name.length < 3 || name.length > 50 || description.length > 1000 || serverPort > 65535 || serverPort < 53640 || maxPlayers > 99 || maxPlayers < 1 || !/^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?|^((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/.test(serverIP)) return fail(400, { msg: "Invalid fields" })

		const gameCount = await prisma.user.findUnique({
			where: { id: user.userId },
			select: { _count: { select: { places: true } } },
		})

		if (gameCount && gameCount?._count.places >= 2) return fail(400, { msg: "You may only have 2 places at most" })

		let place: any
=======
		const name = data.get("name")?.toString()
		const slug = data.get("slug")?.toString().toLowerCase()
		const description = data.get("description")?.toString()

		if (!name || !slug || !description) return fail(400, { msg: "Missing fields" })
		if (name.length < 3 || slug.length < 3 || name.length > 50 || slug.length > 30 || description.length > 1000) return fail(400, { msg: "Invalid fields" })
		if (slug == "create") return fail(400, { msg: Buffer.from("RXJyb3IgMTY6IGR1bWIgbmlnZ2EgZGV0ZWN0ZWQ", "base64").toString("ascii") })
		if (slug == "wisely")
			return fail(400, {
				msg: Buffer.from(
					"V2hhdCB0aGUgZnVjayBkaWQgeW91IGp1c3QgZnVja2luZyBzYXkgYWJvdXQgbWUsIHlvdSBsaXR0bGUgYml0Y2g/IEknbGwgaGF2ZSB5b3Uga25vdyBJIGdyYWR1YXRlZCB0b3Agb2YgbXkgY2xhc3MgaW4gdGhlIE5hdnkgU2VhbHMsIGFuZCBJJ3ZlIGJlZW4gaW52b2x2ZWQgaW4gbnVtZXJvdXMgc2VjcmV0IHJhaWRzIG9uIEFsLVF1YWVkYSwgYW5kIEkgaGF2ZSBvdmVyIDMwMCBjb25maXJtZWQga2lsbHMuCgpJIGFtIHRyYWluZWQgaW4gZ29yaWxsYSB3YXJmYXJlIGFuZCBJJ20gdGhlIHRvcCBzbmlwZXIgaW4gdGhlIGVudGlyZSBVUyBhcm1lZCBmb3JjZXMuIFlvdSBhcmUgbm90aGluZyB0byBtZSBidXQganVzdCBhbm90aGVyIHRhcmdldC4gSSB3aWxsIHdpcGUgeW91IHRoZSBmdWNrIG91dCB3aXRoIHByZWNpc2lvbiB0aGUgbGlrZXMgb2Ygd2hpY2ggaGFzIG5ldmVyIGJlZW4gc2VlbiBiZWZvcmUgb24gdGhpcyBFYXJ0aCwgbWFyayBteSBmdWNraW5nIHdvcmRzLgoKWW91IHRoaW5rIHlvdSBjYW4gZ2V0IGF3YXkgd2l0aCBzYXlpbmcgdGhhdCBzaGl0IHRvIG1lIG92ZXIgdGhlIEludGVybmV0PyBUaGluayBhZ2FpbiwgZnVja2VyLiBBcyB3ZSBzcGVhayBJIGFtIGNvbnRhY3RpbmcgbXkgc2VjcmV0IG5ldHdvcmsgb2Ygc3BpZXMgYWNyb3NzIHRoZSBVU0EgYW5kIHlvdXIgSVAgaXMgYmVpbmcgdHJhY2VkIHJpZ2h0IG5vdyBzbyB5b3UgYmV0dGVyIHByZXBhcmUgZm9yIHRoZSBzdG9ybSwgbWFnZ290LiBUaGUgc3Rvcm0gdGhhdCB3aXBlcyBvdXQgdGhlIHBhdGhldGljIGxpdHRsZSB0aGluZyB5b3UgY2FsbCB5b3VyIGxpZmUuIFlvdSdyZSBmdWNraW5nIGRlYWQsIGtpZC4gSSBjYW4gYmUgYW55d2hlcmUsIGFueXRpbWUsIGFuZCBJIGNhbiBraWxsIHlvdSBpbiBvdmVyIHNldmVuIGh1bmRyZWQgd2F5cywgYW5kIHRoYXQncyBqdXN0IHdpdGggbXkgYmFyZSBoYW5kcy4KCk5vdCBvbmx5IGFtIEkgZXh0ZW5zaXZlbHkgdHJhaW5lZCBpbiB1bmFybWVkIGNvbWJhdCwgYnV0IEkgaGF2ZSBhY2Nlc3MgdG8gdGhlIGVudGlyZSBhcnNlbmFsIG9mIHRoZSBVbml0ZWQgU3RhdGVzIE1hcmluZSBDb3JwcyBhbmQgSSB3aWxsIHVzZSBpdCB0byBpdHMgZnVsbCBleHRlbnQgdG8gd2lwZSB5b3VyIG1pc2VyYWJsZSBhc3Mgb2ZmIHRoZSBmYWNlIG9mIHRoZSBjb250aW5lbnQsIHlvdSBsaXR0bGUgc2hpdC4gSWYgb25seSB5b3UgY291bGQgaGF2ZSBrbm93biB3aGF0IHVuaG9seSByZXRyaWJ1dGlvbiB5b3VyIGxpdHRsZSAiY2xldmVyIiBjb21tZW50IHdhcyBhYm91dCB0byBicmluZyBkb3duIHVwb24geW91LCBtYXliZSB5b3Ugd291bGQgaGF2ZSBoZWxkIHlvdXIgZnVja2luZyB0b25ndWUuCgpCdXQgeW91IGNvdWxkbid0LCB5b3UgZGlkbid0LCBhbmQgbm93IHlvdSdyZSBwYXlpbmcgdGhlIHByaWNlLCB5b3UgZ29kZGFtbiBpZGlvdC4gSSB3aWxsIHNoaXQgZnVyeSBhbGwgb3ZlciB5b3UgYW5kIHlvdSB3aWxsIGRyb3duIGluIGl0LgoKWW91J3JlIGZ1Y2tpbmcgZGVhZCwga2lkZG8u",
					"base64"
				).toString("ascii"),
			})

		if (
			await prisma.place.findUnique({
				where: {
					slug,
				},
			})
		)
			return fail(400, { msg: "A place with this slug already exists" })

>>>>>>> main
		try {
			await prisma.$transaction(async tx => {
				await transaction({ id: user.userId }, { number: 1 }, 10, { note: `Created place ${slug}`, link: `/place/${slug}` }, tx)

				await tx.place.create({
					data: {
						name,
						slug,
						description,
						image: `/place/placeholderIcon${Math.floor(Math.random() * 3) + 1}.png`,
						ownerUsername: user.username,
					},
<<<<<<< HEAD
					select: {
						id: true,
					},
				})

				await transaction({ id: user.userId }, { number: 1 }, 10, { note: `Created place ${name}`, link: `/place/${place.id}` }, tx)
=======
				})
>>>>>>> main
			})
		} catch (e: any) {
			return fail(402, { msg: e.message })
		}

		throw redirect(302, `/place/${slug}`)
	},
}
