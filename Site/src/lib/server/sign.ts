import { createSign } from "node:crypto"

/**
 * Signs a Lua script with a private key by adding a signature to the top of the script.
 * @param data The Lua script to sign.
 * @param assetId The asset ID of the script, if required.
 * @returns A signed version of the script.
 * @example
 * const signedScript = await SignData(`print "Hello, world!"`)
 */
export async function SignData(data: string, assetId?: number) {
	const signed = `${assetId ? `--rbxassetid%${assetId}%` : ""}\n${data}`
	const sig = createSign("sha1")
		.update(signed)
		.sign(await Bun.file("../data/PrivateKey.pem").text(), "base64")
	return `--rbxsig%${sig}%${signed}`
}
