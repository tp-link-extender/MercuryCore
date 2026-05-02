console.log("Hello via Bun!")

const url = "http://localhost:2009"

const res = await fetch(`${url}/ownsOne`, {
	method: "POST",
})
const body = await res.text()
console.log(res)
console.log(body)
