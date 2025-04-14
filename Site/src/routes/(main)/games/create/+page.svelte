<script lang="ts">
	import Head from "$components/Head.svelte"
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"
	import Textarea from "$components/forms/Textarea.svelte"
	import beautifyCurrency from "$lib/beautifyCurrency"
	import { superForm } from "sveltekit-superforms/client"

	const { data } = $props()

	const formData = superForm(data.form)
	export const snapshot = formData

	const [, c1, c2] = beautifyCurrency(data.price)
</script>

<Head name={data.siteName} title="Create a place" />

<h1 class="text-center">Create a place</h1>

<Form
	{formData}
	nopad
	class="ctnr pt-12 max-w-200 light-text"
	submit="Create ({data.currencySymbol}{c1}{c2 ? '.' : ''}{c2})">
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
		placeholder="1024-65536"
		help="Using a port number lower than 49152 may not work correctly." />
	<Input
		{formData}
		type="number"
		name="maxPlayers"
		label="Player limit"
		placeholder="1-99 players" />
	<Input
		{formData}
		type="checkbox"
		name="privateServer"
		label="Private server?" />
</Form>
