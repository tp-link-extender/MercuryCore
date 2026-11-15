<script lang="ts">
	import Codearea from "$components/forms/Codearea.svelte"
	import Form from "$components/forms/Form.svelte"
	import { stylingForm } from "./settings.remote.js"

	const { data }: { data: import("./$types").PageData } = $props()

	let { user } = $derived(data)

	const defaultCss =
		user.css || "/* Enter your CSS here! Maximum 10 000 characters. */\n"
</script>

<Form formData={stylingForm} submit="<fa fa-save></fa> Save changes">
	<Codearea
		formData={stylingForm}
		rows={15}
		name="css"
		defaultValue={defaultCss}
		label="Custom CSS"
		placeholder="Maximum 10000 characters"
		help="This styling will be applied to every page, only for you. Maximum 10 000 characters." />

	<span class="pr-2">
		<button
			class="btn btn-secondary"
			type="button"
			onclick={() => {
				const css = stylingForm.fields.css.value()
				if (!css) return
				let style = document.getElementById("custom-css")
				if (!style) style = document.createElement("style")

				style.id = "custom-css"
				style.textContent = css
				document.body.appendChild(style)
			}}>
			Preview
		</button>
	</span>
</Form>
