export function GET() {
	// get bearer token from header instead of insecure url (temporarily disabled)
	// const auth = request.headers.get("Authorization")
	// if (!auth || !auth.startsWith("Bearer ") || auth.slice(7) !== ORBITER_KEY)
	// 	error(403, "Unauthorised")

	return Response.json({
		ChatFilter: "whitelist",
	})
}
