<script lang="ts">
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"
	import { superForm } from "sveltekit-superforms/client"

	const {
		data
	}: {
		data: import("./$types").PageData
	} = $props()

	const formData = superForm(data.networkForm)
	const { form } = formData

	if (data.serverAddress) $form.serverAddress = data.serverAddress
	if (data.serverPort) $form.serverPort = data.serverPort
	if (data.maxPlayers) $form.maxPlayers = data.maxPlayers
</script>

<Form
	{formData}
	submit=" <fa fa-save></fa> Save changes"
	action="?/network&tab=Network">
	<Input {formData} name="serverAddress" label="Address" />
	<Input
		{formData}
		name="serverPort"
		label="Port"
		type="number"
		help="Using a port number lower than 49152 may not work correctly." />
	<Input {formData} name="maxPlayers" label="Server limit" type="number" />
</Form>
