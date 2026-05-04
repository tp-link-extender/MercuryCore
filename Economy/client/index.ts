import { request } from "./api"
import { SerialiseItem } from "./items"
import { User } from "./types"

console.log("Hello via Bun!")

const u = new User("test")
const su = SerialiseItem(u)

// const res = await fetch(`${url}/stipend`, {
// 	method: "POST",
// 	body: su,
// })
// const body = await res.text()
// console.log(res)
// console.log(body)
const buf = await request("stipend", su)
console.log(buf.code)
console.log(buf.body)
