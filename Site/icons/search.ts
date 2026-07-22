/// <reference types="@types/bun" />

import fa from "../src/icons.json"

const out = await Bun.$`bunx unocss ./src/**/*.svelte --stdout`.quiet().text()

const far = /fa-([a-zA-Z0-9-]+)/

const classes = out.split("\n").map(s => s.match(far)?.[1])
const deduped = [...new Set(classes)].filter(Boolean) as string[]

const fal: { [_: string]: string } = fa
const script = deduped.map(c => `SelectMore("u${fal[c].padStart(4, "0")}")`)

await Bun.write("./icons/script.txt", script.join("\n"))
