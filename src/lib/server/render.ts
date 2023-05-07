import fs from "fs"
import puppeteer from "puppeteer"
import serve from "koa-static"
import Koa from "koa"

let port = 3000

export default async function (username: string, avatar: any) {
	const browser = await puppeteer.launch({ headless: "new" })
	const page = await browser.newPage()

	const app = new Koa()
	app.use(serve("./avatar/dist"))

	if (port++ > 3200) port = 3000

	const server = app.listen(port)
	const timeout = setTimeout(() => server.close(), 10000)

	console.log(`Image server ${port} started for ${username}`)

	await page.goto(`http://localhost:${port}?c=${JSON.stringify(avatar)}`)
	await page.setViewport({ width: 150, height: 150 })

	await page.waitForSelector("canvas")
	console.log(`Image render for ${username} complete`)

	server.close()
	clearTimeout(timeout)

	if (!fs.existsSync("data/avatars")) fs.mkdirSync("data/avatars")

	await page.screenshot({
		path: `data/avatars/${username}.png`,
		omitBackground: true,
	})
	await browser.close()
}
