<script lang="ts">
	import superForm from "$lib/superForm"

	export let data: import("./$types").PageData
	const formData = superForm(data.networkForm)

	if (data.serverIP)
		formData.form.update(v => {
			v.serverIP = data.serverIP
			return v
		})
	if (data.serverPort)
		formData.form.update(v => {
			v.serverPort = data.serverPort
			return v
		})
	if (data.maxPlayers)
		formData.form.update(v => {
			v.maxPlayers = data.maxPlayers
			return v
		})
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
