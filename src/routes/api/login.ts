function err(err: string | boolean) {
	// "boolean" for no error message
	return {
		status: 302,
		headers: {
			location: `/login#${err || "error"}`,
		},
	}
}

/** @type {import("@sveltejs/kit").RequestHandler} */
export async function POST({ request }: { request: any }) {
	const formData = await request.formData()
	const username = formData.get("username")
	const password = formData.get("password")

	const easyChecks = [
		[username.length <= 3, "ushort"],
		[username.length > 30, "ulong"],
		[password.length < 16, "pshort"],
		[password.length > 6969, "plong"],
	]

	for (const [condition, code] of easyChecks) {
		if (condition) return err(code)
	}

	return {
		status: 302,
		headers: {
			location: "/home",
		},
	}
}
