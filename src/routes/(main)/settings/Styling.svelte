<script lang="ts">
	import { superForm } from "sveltekit-superforms/client"

	export let data: import("./$types").PageData
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

	<button
		class="btn btn-secondary"
		on:click|preventDefault={() => {
			if (!$form.css) return
			const style = document.getElementById("custom-css")
			console.log(style)
			if (!style) return
			style.id = "custom-css"
			style.innerHTML = $form.css.replaceAll(";", " !important;")
			document.head.appendChild(style)
		}}>
		Preview
	</button>
</Form>
