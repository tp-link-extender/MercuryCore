<script lang="ts">
	import { superForm } from "sveltekit-superforms/client"
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"

	const { data }: { data: import("./$types").PageData } = $props()

	const formData = superForm(data.privacyForm)
	const { form } = formData

	if (data.privateServer) $form.privateServer = data.privateServer
</script>

<Form
	{formData}
	submit=" <fa fa-save></fa> Save changes"
	action="?/privacy&tab=Privacy">
	<Input
		{formData}
		name="privateServer"
		label="Private server"
		type="checkbox" />
</Form>
