import { defineEnvVars } from "@sveltejs/kit/env"

// Every variable read through $app/env/private. Keys that were previously static must be set, the rest are checked where they are used
const optional = {
	schema: (value: string | undefined) => value,
}

export const variables = defineEnvVars({
	DATABASE_PASSWORD: optional,
	DATABASE_ROOT_PASSWORD: optional,
	DATABASE_USER: optional,
	GAMESERVER_KEY: optional,
	OPEN_CLOUD_KEY: {},
	RCC_KEY: {},
})
