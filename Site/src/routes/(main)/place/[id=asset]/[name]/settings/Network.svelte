<script lang="ts">
	import { superForm } from "sveltekit-superforms/client"
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"

	const {
		data
	}: {
		data: import("./$types").PageData
	} = $props()

	const formData = superForm(data.networkForm)
	let { form } = $derived(formData)

	if (data.dedicated) $form.dedicated = data.dedicated
	if (data.serverAddress) $form.serverAddress = data.serverAddress
	if (data.serverPort) $form.serverPort = data.serverPort
	if (data.maxPlayers) $form.maxPlayers = data.maxPlayers
</script>

<Form
	{formData}
	submit=" <fa fa-save></fa> Save changes"
	action="?/network&tab=Network">
	<Input
		{formData}
		name="dedicated"
		label="Dedicated server"
		type="checkbox" />
	<Input
		{formData}
		disabled={$form.dedicated}
		name="serverAddress"
		label="Address" />
	<Input
		{formData}
		disabled={$form.dedicated}
		name="serverPort"
		label="Port"
		type="number"
		help="Using a port number lower than 49152 may not work correctly." />
	<Input {formData} name="maxPlayers" label="Server limit" type="number" />
</Form>
