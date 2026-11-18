<script lang="ts">
	import Form from "#components/forms/Form.svelte"
	import Input from "#components/forms/Input.svelte"
	import Select from "#components/forms/Select.svelte"
	import { networkForm } from "./settings.remote.js"

	const { data }: { data: import("./$types").PageData } = $props()

	const networkFormFor = networkForm.for(data.id)
	const dedicated = $derived(
		networkFormFor.fields.dedicated.value() ?? data.dedicated
	)
</script>

<Form formData={networkFormFor} submit=" <fa fa-save></fa> Save changes">
	<Input
		formData={networkFormFor}
		name="dedicated"
		label="Dedicated server"
		type="checkbox"
		defaultValue={data.dedicated} />
	<Input
		formData={networkFormFor}
		disabled={dedicated}
		name="serverAddress"
		label="Address"
		defaultValue={data.serverAddress} />
	<Input
		formData={networkFormFor}
		disabled={dedicated}
		name="serverPort"
		label="Port"
		type="number"
		defaultValue={data.serverPort.toString()}
		help="Using a port number lower than 49152 may not work correctly." />
	<Select
		formData={networkFormFor}
		name="clientVersion"
		label="Client version"
		options={data.clientVersions}
		selected={data.clientVersion.toString()} />
	<Input
		formData={networkFormFor}
		name="maxPlayers"
		label="Server limit"
		type="number"
		defaultValue={data.maxPlayers.toString()} />
</Form>
