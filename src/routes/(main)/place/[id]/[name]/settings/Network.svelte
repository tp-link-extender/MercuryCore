<script lang="ts">
	import superForm from "$lib/superForm"

	export let data: import("./$types").PageData
	const formData = superForm(data.networkForm)
	const { form } = formData

	if (data.serverIP) $form.serverIP = data.serverIP
	if (data.serverPort) $form.serverPort = data.serverPort
	if (data.maxPlayers) $form.maxPlayers = data.maxPlayers
</script>

<Form {formData} submit="Save changes" action="?/network&tab=Network">
	<Input {formData} name="serverIP" label="Address" />
	<Input
		{formData}
		name="serverPort"
		label="Port"
		type="number"
		help="Using a port number lower than 49152 may not work correctly." />
	<Input {formData} name="maxPlayers" label="Server Limit" type="number" />
</Form>
