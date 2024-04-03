<script lang="ts">
	import { superForm } from "sveltekit-superforms/client"

	export let data: import("./$types").PageData
	const { user } = data
	const formData = superForm(data.stylingForm)
	const { form } = formData

	if (user.css) $form.css = user.css || ""

	formData.submit
</script>

<Form {formData} action="?/styling" submit="<fa fa-save></fa> Save changes">
	<Codearea
		{formData}
		rows={15}
		name="css"
		label="Custom CSS"
		placeholder="Maximum 10000 characters"
		help="This styling will be applied to every page, only for you. Maximum 10000 characters." />
</Form>
