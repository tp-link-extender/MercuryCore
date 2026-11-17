import { defineEnvVars } from "@sveltejs/kit/env"

// Every variable read through $app/env/private. The Site checks the values where they are used, so each one is optional here
const optional = {
	schema: (value: string | undefined) => value,
}

export const variables = defineEnvVars({
	DATABASE_PASSWORD: optional,
	DATABASE_ROOT_PASSWORD: optional,
	DATABASE_USER: optional,
	GAMESERVER_KEY: optional,
	OPEN_CLOUD_KEY: optional,
	RCC_KEY: optional,
})
