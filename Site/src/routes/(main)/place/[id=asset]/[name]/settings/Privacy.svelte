<script lang="ts">
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"
	import { superForm } from "$lib/validate"

	const { data }: { data: import("./$types").PageData } = $props()

	let formData = $derived(superForm(data.privacyForm))
	let { form } = $derived(formData)

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
