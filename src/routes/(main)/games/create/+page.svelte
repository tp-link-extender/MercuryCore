<script lang="ts">
	import superForm from "$lib/superForm"

	export let data
	const formData = superForm(data.form)

	export const snapshot = formData
</script>

<Head title="Create a place" />

<h1 class="text-center">Create a place</h1>

<Form
	{formData}
	class="ctnr pt-12 max-w-200 light-text"
	submit="Create ( <fa fa-gem></fa> Free )">
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
		label="Server port"
		placeholder="1024 - 65536"
		help="Using a port number lower than 49152 may not work correctly." />
	<Input
		{formData}
		type="number"
		name="maxPlayers"
		label="Player limit"
		placeholder="1 - 99 players" />
	<Input
		{formData}
		type="checkbox"
		name="privateServer"
		label="Private server?" />
</Form>
