// Builds on the Svelte fade function to allow for
// easier delays for staggered animations

// import { getUser } from "@lucia-auth/sveltekit/client"
// import { get } from "svelte/store"
import { fade } from "svelte/transition"

// Is called before handleSession() for some reason
// const user = getUser()

export default (node: any, props: any = { duration: 300 }) => {
	// if (get(user)?.animationSettings == "off") return () => {}
	if (props.num && props.total)
		props.delay = (props.num * 150) / Math.min(props.total, props?.max || 6)
	return fade(node, props)
}
