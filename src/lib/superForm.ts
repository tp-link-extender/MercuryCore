import { superForm } from "sveltekit-superforms/client"

/**
 * just so ion have to type { taintedMessage: false } every time
 */
const sf: typeof superForm = (form, options) =>
	superForm(form, { taintedMessage: false, ...options })

export default sf
