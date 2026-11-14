// Sets up SurrealDB for the Site: the main namespace and database, the Site's own user, and a non-default root password.
// The Site imports it when it starts its own SurrealDB, and it also runs on its own: bun run db:setup [--add-only] [--url ws://localhost:8000]
// On its own it reads DATABASE_ROOT_PASSWORD, DATABASE_USER and DATABASE_PASSWORD from the environment (Bun loads .env in the current directory). It runs outside SvelteKit, so it only uses relative imports.
import { parseArgs } from "node:util"
import { type AnyAuth, Surreal } from "surrealdb"
import {
	type DatabaseCredentials,
	databaseCredentials,
	rootPassword,
} from "./dbCredentials"

const legacyRootPassword = "root"
const namespace = "main"
const database = "main"

export interface SetupOptions {
	/** Define the namespace, database and the Site's user, but don't change the root password. */
	addOnly: boolean
	rootPassword: string
	site: DatabaseCredentials
	url: URL
}

async function signIn(url: URL, auth: AnyAuth): Promise<Surreal | null> {
	const db = new Surreal()
	await db.connect(url, { reconnect: false })
	try {
		await db.signin(auth)
		return db
	} catch {
		await db.close()
		return null
	}
}

async function connectWithRetry(url: URL): Promise<void> {
	for (let attempt = 1; ; attempt++)
		try {
			const db = new Surreal()
			await db.connect(url, { reconnect: false })
			await db.close()
			return
		} catch (err) {
			if (attempt === 10) throw err
			await Bun.sleep(1000)
		}
}

const rootSignIn = (url: URL, password: string): Promise<Surreal | null> =>
	signIn(url, { password, username: "root" })

/**
 * Sets up the namespace, database and the Site's database user, and rotates the root password away from the old default. Safe to run more than once. Never logs a password.
 * @param o The setup options. Passwords must already be validated with checkPassword.
 */
export async function setupDatabase(o: SetupOptions): Promise<void> {
	await connectWithRetry(o.url)

	let root = await rootSignIn(o.url, o.rootPassword)
	let legacy = false
	if (!root) {
		root = await rootSignIn(o.url, legacyRootPassword)
		legacy = true
	}
	if (!root)
		throw new Error(
			"Couldn't sign in to SurrealDB as root with DATABASE_ROOT_PASSWORD or the old default password."
		)

	try {
		// Passwords are literals because DEFINE USER and ALTER USER don't take parameters. checkPassword only allows [A-Za-z0-9_-], so they can't escape the quotes.
		await root.query(`
			DEFINE NAMESPACE OVERWRITE ${namespace};
			USE NS ${namespace};
			DEFINE DATABASE OVERWRITE ${database} STRICT;
			USE DB ${database};
			DEFINE USER OVERWRITE ${o.site.user} ON DATABASE PASSWORD '${o.site.password}' ROLES EDITOR;
		`)
		console.log(
			`Database user ${o.site.user} is defined on ${namespace}/${database}`
		)

		if (legacy && !o.addOnly) {
			await root.query(
				`ALTER USER root ON ROOT PASSWORD '${o.rootPassword}';`
			)
			console.log("Changed the root password to DATABASE_ROOT_PASSWORD")
		}
	} finally {
		await root.close()
	}

	const site = await signIn(o.url, {
		database,
		namespace,
		password: o.site.password,
		username: o.site.user,
	})
	if (!site)
		throw new Error(
			`The Site's user ${o.site.user} can't sign in after setup.`
		)
	await site.close()

	const stillDefault = await rootSignIn(o.url, legacyRootPassword)
	if (!stillDefault) return
	await stillDefault.close()
	if (o.addOnly) {
		console.warn(
			"Warning: root still signs in with the default password. Run setup again without --add-only once the Site has moved to its own user."
		)
		return
	}
	throw new Error(
		"root still signs in with the default password after setup."
	)
}

async function main(): Promise<void> {
	const { values } = parseArgs({
		options: {
			"add-only": { default: false, type: "boolean" },
			url: { default: "ws://localhost:8000", type: "string" },
		},
	})
	try {
		await setupDatabase({
			addOnly: values["add-only"],
			rootPassword: rootPassword(process.env),
			site: databaseCredentials(process.env),
			url: new URL(values.url),
		})
		console.log("Database setup finished")
	} catch (err) {
		console.error(err instanceof Error ? err.message : err)
		process.exit(1)
	}
}

if (import.meta.main) await main()
