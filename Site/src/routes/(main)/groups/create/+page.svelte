<script lang="ts">
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"
	import Head from "$components/Head.svelte"
	import beautifyCurrency from "$lib/beautifyCurrency"
	import { superForm } from "$lib/validate"

	const { data } = $props()

	let formData = $derived(superForm(data.form))
	export const snapshot = formData

	const [, c1, c2] = beautifyCurrency(data.price)
</script>

<Head name={data.siteName} title="Create a group" />

<h1 class="text-center">Create a group</h1>

<Form
	{formData}
	nopad
	class="ctnr pt-12 max-w-200 light-text"
	submit="Create ({data.currencySymbol}{c1}{c2 ? '.' : ''}{c2})">
	<Input
		{formData}
		name="name"
		label="Group name"
		placeholder="This cannot be changed. Choose wisely." />
</Form>
