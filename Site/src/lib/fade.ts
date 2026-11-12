// Builds on the Svelte fade function to allow for easier delays for staggered animations

// import { get } from "svelte/store"
import { type FadeParams, fade } from "svelte/transition"

interface Params extends FadeParams {
	max?: number
	num?: number
	total?: number
}

const fadeTransition = (node: HTMLElement, props?: Params) => {
	const params = { duration: 300, ...props }
	// animationsettings doesn't work, todo look at this again in another year or so
	// if (get(user)?.animationSettings === "off") return () => {}
	if (params.num && params.total)
		params.delay =
			(params.num * 150) / Math.min(params.total, params.max || 6)
	return fade(node, params)
}

export default fadeTransition
