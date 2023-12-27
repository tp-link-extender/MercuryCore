<script lang="ts">
	import { superForm } from "sveltekit-superforms/client"

	export let data
	const formData = superForm(data.form, {
		taintedMessage: false,
	})

	export const snapshot = formData
</script>

<Head title="Create a post in {data.categoryName}" />

<h1 class="text-center">Create a post in {data.categoryName}</h1>

<div class="ctnr pt-12 max-w-200 light-text">
	<Form {formData} submit="Post">
		<Input
			{formData}
			name="title"
			description="Post title"
			placeholder="Make sure to make it accurate" />
		<Textarea
			{formData}
			rows="3"
			name="content"
			description="Post content"
			placeholder="Up to 3000 characters" />
	</Form>
</div>
