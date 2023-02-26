import crypto from "crypto"
import fs from 'fs'

export function GetSig(data : string) {
    const sign = crypto.createSign("SHA1")
    const key = fs.readFileSync("./keys/PrivateKey.pem")

    sign.write(data)
    sign.end()

    return sign.sign(key, "base64")

}

export function SignData(data : string, assetID : number | boolean = false) {
    if(assetID) data = `--rbxassetid%${assetID}%\n${data}`
    else data = `\n${data}`
    return `--rbxsig%${GetSig(data)}%${data}`
}