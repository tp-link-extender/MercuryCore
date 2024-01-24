// Builds on the Svelte fade function to allow for
// easier delays for staggered animations

// import { get } from "svelte/store"
import { fade, type FadeParams } from "svelte/transition"

type Params = FadeParams & {
	num?: number
	total?: number
	max?: number
}

export default (node: HTMLElement, props: Params = { duration: 300 }) => {
	// if (get(user)?.animationSettings === "off") return () => {}
	if (props.num && props.total)
		props.delay = (props.num * 150) / Math.min(props.total, props?.max || 6)
	return fade(node, props)
}
