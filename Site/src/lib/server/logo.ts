// Fun Unicode art 'logo', inspired by HybridOS

import { blue, green, magenta } from "picocolors"

const logo = `
  ██▙    ▟██ ${blue("Started")}
  ███▙  ▟███ ▟████▙ ▗████▛▗█████▌██   ██ ▟████▙▝█▙    ▗█▛
  ██▝█▙▟█▘██▐█▌  ▐█▌██▘   ██▘    ██   ██▐█▛     ▝█▙  ▗█▛
  ██ ▝██▘ ██▐█████▛ ██    ██     ██   ██▐█▌      ▝█▙▗█▛
  ██      ██▐█▌     ██    ██▖    ██▖ ▗██▐█▌       ▝██▛
  ▛▀      ▜█ ▜████▛ ██    ▝█████▙▝█████▘▐█▌       ▗█▛
  ▗██████▛                                       ▗█▛
  ██▘    ▗█████▖ ▟████▛▗█████▖                  ▗█▛
  ██     ██   ██▐█▛    ██   ██ ${blue("Self-hostable MMO")}
  ██     ██   ██▐█▌    ██████▘ ${blue("game creation platform:")}
  ██▖    ██   ██▐█▌    ██      ${green("Build-your-own-Roblox")}
  ▝█████▙▝█████▘▐█▌    ▝█████▘
`

let done = false

export default () => {
	if (done) return
	done = true
	console.log(magenta(logo))
}
