<script lang="ts">
	import Head from "$components/Head.svelte"
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"
	import { superForm } from "sveltekit-superforms/client"

	let { data } = $props();

	const formData = superForm(data.form)
	export const snapshot = formData
</script>

<Head name={data.siteName} title="Create a forum category" />

<h1 class="text-center">Create a forum category</h1>

<div class="ctnr pt-12 max-w-200 light-text">
	<Form {formData} submit="Create">
		<Input
			{formData}
			name="name"
			label="Category name"
			placeholder="Make sure to make it accurate" />
		<Input
			{formData}
			name="description"
			label="Category description"
			placeholder="Give it some further detail" />
	</Form>
</div>
