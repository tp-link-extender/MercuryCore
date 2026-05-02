import { SerialiseItem } from "./items"
import { User } from "./types"

console.log("Hello via Bun!")

const url = "http://localhost:2009"

const u = new User("test")
const su = SerialiseItem(u)

const res = await fetch(`${url}/stipend`, {
	method: "POST",
	body: su,
})
const body = await res.text()
console.log(res)
console.log(body)
