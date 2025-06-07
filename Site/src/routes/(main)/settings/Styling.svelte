<script lang="ts">
	import Codearea from "$components/forms/Codearea.svelte"
	import Form from "$components/forms/Form.svelte"
	import { superForm } from "sveltekit-superforms/client"

	const { data }: { data: import("./$types").PageData } = $props()

	const { user } = data
	const formData = superForm(data.stylingForm)
	const { form } = formData

	$form.css =
		user.css || "/* Enter your CSS here! Maximum 10 000 characters. */\n"
</script>

<Form {formData} action="?/styling" submit="<fa fa-save></fa> Save changes">
	<Codearea
		{formData}
		rows={15}
		name="css"
		label="Custom CSS"
		placeholder="Maximum 10000 characters"
		help="This styling will be applied to every page, only for you. Maximum 10 000 characters." />

	<span class="pr-2">
		<button
			class="btn btn-secondary"
			onclick={e => {
				e.preventDefault()
				if (!$form.css) return
				let style = document.getElementById("custom-css")
				if (!style) style = document.createElement("style")

				style.id = "custom-css"
				style.innerHTML = $form.css
				document.body.appendChild(style)
			}}>
			Preview
		</button>
	</span>
</Form>
