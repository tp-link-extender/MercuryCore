import crypto from "crypto"
import fs from "fs"

/**
 * Signs a Lua script with a private key by adding a signature to the top of the script.
 * @param data The Lua script to sign.
 * @param assetId The asset ID of the script, if required.
 * @returns A signed version of the script.
 * @example
 * const signedScript = SignData(`
 * 	print "Hello, world!"
 * `)
 */
export function SignData(data: string, assetId?: number) {
	data = assetId ? `--rbxassetid%${assetId}%\n${data}` : `\n${data}`

	const sign = crypto.createSign("SHA1"),
		key = fs.readFileSync("./keys/PrivateKey.pem")

	sign.write(data)
	sign.end()

	return `--rbxsig%${sign.sign(key, "base64")}%${data}`
}
