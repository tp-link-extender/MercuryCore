import { json } from "@sveltejs/kit"

export const GET = () =>
	json({
		data: [
			"0.75.0pcplayer",
			"0.75.0pcplayeraskljfLUZF",
			"0.235.0pcplayer",
			"0.285.0pcplayer",
		],
	})
