// Editing this file in dev mode may cause the
// server to start multiple times, resulting in a
// port conflict which may crash the dev server.

import fs from "fs"
import puppeteer from "puppeteer"
import serve from "koa-static"
import Koa from "koa"

const app = new Koa()
app.use(serve("./avatar/dist"))

const port = Math.floor(Math.random() * 100) + 3001

app.listen(port)
console.log(`Image server started on port ${port}`)

export default async function (
	username: string,
	avatar: any,
	bodyShot = false
) {
	console.time(
		`${bodyShot ? "Body" : "Head"}shot render for ${username}`
	)
	const browser = await puppeteer.launch({ headless: "new" })
	const page = await browser.newPage()

	if (!bodyShot) {
		delete avatar.LeftLeg
		delete avatar.RightLeg
	}

	await page.goto(
		`http://localhost:${port}?c=${JSON.stringify(avatar)}${
			bodyShot ? "&f" : ""
		}`
	)
	await page.setViewport(
		bodyShot ? { width: 300, height: 400 } : { width: 150, height: 150 }
	)

	await page.waitForSelector("canvas")
	console.timeEnd(
		`${bodyShot ? "Body" : "Head"}shot render for ${username}`
	)

	if (!fs.existsSync("data/avatars")) fs.mkdirSync("data/avatars")

	await page.screenshot({
		path: `data/avatars/${username}${bodyShot ? "-body" : ""}.png`,
		omitBackground: true,
	})
	await browser.close()

	return `api/avatar/${username}${bodyShot ? "-body" : ""}`
}
