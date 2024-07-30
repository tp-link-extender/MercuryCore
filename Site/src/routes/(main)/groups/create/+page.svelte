<script lang="ts">
	import Head from "$components/Head.svelte"
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"
	import { superForm } from "sveltekit-superforms/client"

	export let data

	const formData = superForm(data.form)
	export const snapshot = formData
</script>

<Head title="Create a group" />

<h1 class="text-center">Create a group</h1>

<Form
	{formData}
	nopad
	class="ctnr pt-12 max-w-200 light-text"
	submit="Create ({data.currencySymbol}10)">
	<Input
		{formData}
		name="name"
		label="Group name"
		placeholder="This cannot be changed. Choose wisely." />
</Form>
