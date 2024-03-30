import { createSign } from "node:crypto"
import fs from "node:fs"

/**
 * Signs a Lua script with a private key by adding a signature to the top of the script.
 * @param data The Lua script to sign.
 * @param assetId The asset ID of the script, if required.
 * @returns A signed version of the script.
 * @example
 * const signedScript = SignData(`print "Hello, world!"`)
 */
export function SignData(data: string, assetId?: number) {
	const signed = `${assetId ? `--rbxassetid%${assetId}%` : ""}\n${data}`

	return `--rbxsig%${createSign("sha1")
		.update(signed)
		.sign(fs.readFileSync("./keys/PrivateKey.pem"), "base64")}%${signed}`
}
