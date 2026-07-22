/// <reference types="@types/bun" />

import fa from "../src/icons.json"

const out = await Bun.$`bunx unocss ./src/**/*.svelte --stdout`.quiet().text()

const far = /fa-([a-zA-Z0-9-]+)/

const classes = out
	.split("\n")
	.filter(s => s.match(far))
	.map(s => s.match(far)?.[1])
const deduped = [...new Set(classes)].filter(Boolean) as string[]

const fal: { [_: string]: string } = fa
const positions = deduped.map(c => fal[c])

await Bun.write("./icons/positions.txt", positions.join("\n"))
