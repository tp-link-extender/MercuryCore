<script lang="ts">
	import { superForm } from "sveltekit-superforms/client"

	export let data
	const formData = superForm(data.form, {
		taintedMessage: false,
	})

	export const snapshot = formData
</script>

<Head title="Create a place" />

<h1 class="text-center">Create a place</h1>

<Form {formData} class="ctnr pt-12 max-w-200 light-text">
	<Input
		{formData}
		name="name"
		label="Place name"
		placeholder="Make sure to make it accurate" />
	<Textarea
		{formData}
		name="description"
		label="Description"
		placeholder="Up to 1000 characters" />
	<Input
		{formData}
		name="serverIP"
		label="Server IP"
		placeholder="You can use a URL instead of an IP if you wish" />
	<Input
		{formData}
		type="number"
		name="serverPort"
		label="Server Port"
		placeholder="1024 - 65536"
		help="Using a port number lower than 49152 may not work correctly." />
	<Input
		{formData}
		type="number"
		name="maxPlayers"
		label="Player Limit"
		placeholder="1 - 99 players" />
	<Input
		{formData}
		type="checkbox"
		name="privateServer"
		label="Private Server" />
</Form>
