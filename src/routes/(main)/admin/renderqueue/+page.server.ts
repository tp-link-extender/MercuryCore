import surql from "$lib/surrealtag"
import { query } from "$lib/server/surreal"

export const load = () => ({
	status: query(surql`stuff:ping.render`) as unknown as string,
	queue: [
		{
			id: 1,
			type: "Avatar",
			user: {
				number: 1,
				status: "Online" as "Playing" | "Online" | "Offline",
				username: "Heliodex",
			},
			status: "Pending",
			created: new Date().toUTCString(),
			completed: null,
		},
		{
			id: 2,
			type: "Asset",
			asset: {
				id: 1,
				name: "Test Asset",
			},
			status: "Pending",
			created: new Date().toUTCString(),
			completed: null,
		},
	],
})
