<script lang="ts">
	import { superForm } from "sveltekit-superforms/client"

	export let data: import("./$types").PageData
	const formData = superForm(data.privacyForm)
	const { form } = formData

	if (data.privateServer) $form.privateServer = data.privateServer
</script>

<Form
	{formData}
	submit="<fa fa-save></fa> Save changes"
	action="?/privacy&tab=Privacy">
	<Input
		{formData}
		name="privateServer"
		label="Private Server"
		type="checkbox" />
</Form>
