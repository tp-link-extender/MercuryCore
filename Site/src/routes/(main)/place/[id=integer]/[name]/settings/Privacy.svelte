<script lang="ts">
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"
	import { superForm } from "sveltekit-superforms/client"

	const { data }: { data: import("./$types").PageData } = $props()

	const formData = superForm(data.privacyForm)
	const { form } = formData

	if (data.privateServer) $form.privateServer = data.privateServer
</script>

<Form
	{formData}
	submit=" <fa fa-save class='pr-2'></fa> Save changes"
	action="?/privacy&tab=Privacy">
	<Input
		{formData}
		name="privateServer"
		label="Private server"
		type="checkbox" />
</Form>
