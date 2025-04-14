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

	if (data.serverIP) $form.serverIP = data.serverIP
	if (data.serverPort) $form.serverPort = data.serverPort
	if (data.maxPlayers) $form.maxPlayers = data.maxPlayers
</script>

<Form
	{formData}
	submit=" <fa fa-save class='pr-2'></fa> Save changes"
	action="?/network&tab=Network">
	<Input {formData} name="serverIP" label="Address" />
	<Input
		{formData}
		name="serverPort"
		label="Port"
		type="number"
		help="Using a port number lower than 49152 may not work correctly." />
	<Input {formData} name="maxPlayers" label="Server limit" type="number" />
</Form>
