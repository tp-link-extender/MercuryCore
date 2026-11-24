import { buildLoadscript } from "#lib/server/loadscript.ts"
import type {
	LoadscriptName,
	LoadscriptValuesByName,
} from "#lib/server/loadscripts.gen.ts"

const directory = "../data/server/loadscripts"

/**
 * Reads the 2013 loadscript with this name and fills in its placeholders.
 * The values are typed from the templates, so a value the template doesn't use, or one it needs but doesn't get, fails the typecheck.
 */
export async function buildNamedLoadscript<N extends LoadscriptName>(
	name: N,
	values: LoadscriptValuesByName[N]
): Promise<string> {
	const template = await Bun.file(`${directory}/${name}.lua`).text()
	return buildLoadscript(template, values)
}
