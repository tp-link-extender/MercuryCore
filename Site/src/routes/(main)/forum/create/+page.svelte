<script lang="ts">
	import Head from "$components/Head.svelte"
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"
	import Textarea from "$components/forms/Textarea.svelte"
	import { superForm } from "sveltekit-superforms/client"

	export let data

	const formData = superForm(data.form)
	export const snapshot = formData
</script>

<Head title="Create a post in {data.categoryName}" />

<div class="text-center">
	<h1>Create a post in {data.categoryName}</h1>
	<a href="/forum/{data.categoryName}" class="no-underline accent-text">
		<fa fa-caret-left />
		Back to forum
	</a>
</div>

<div class="ctnr pt-12 max-w-200 light-text">
	<Form {formData} submit="Post">
		<Input
			{formData}
			name="title"
			label="Post title"
			placeholder="Make sure to make it accurate" />
		<Textarea
			{formData}
			rows={3}
			name="content"
			label="Post content"
			placeholder="Up to 3000 characters" />
	</Form>
</div>
