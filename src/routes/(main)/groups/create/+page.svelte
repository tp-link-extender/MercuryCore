<script lang="ts">
	import superForm from "$lib/superForm"

	export let data
	const formData = superForm(data.form)

	export const snapshot = formData
</script>

<Head title="Create a group" />

<h1 class="text-center">Create a group</h1>

<Form
	{formData}
	class="ctnr pt-12 max-w-200 light-text"
	submit="Create ( <fa fa-gem></fa> 10 )">
	<Input
		{formData}
		name="name"
		label="Group name"
		placeholder="This cannot be changed. Choose wisely." />
</Form>
