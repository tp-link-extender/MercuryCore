<script lang="ts">
	import { superForm } from "sveltekit-superforms/client"

	export let data

	const formData = superForm(data.form, {
		taintedMessage: false,
	})

	export const snapshot = formData
</script>

<Head title="Create a forum category" />

<h1 class="text-center">Create a forum category</h1>

<div class="ctnr pt-12 max-w-200 light-text">
	<Form {formData} submit="Create">
		<Input
			{formData}
			name="name"
			description="Category name"
			placeholder="Make sure to make it accurate" />
		<Input
			{formData}
			name="description"
			description="Category description"
			placeholder="Give it some further detail" />
	</Form>
</div>
