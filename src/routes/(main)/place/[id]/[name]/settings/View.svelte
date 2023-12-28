<script lang="ts">
	import { get } from "svelte/store"
	import superForm from "$lib/superForm"

	export let data: import("./$types").PageData
	const formData = superForm(data.viewForm)

	if (data.name && !get(formData.form).title)
		formData.form.update(v => {
			v.title = data.name
			return v
		})
	if (data.description && !get(formData.form).description)
		formData.form.update(v => {
			v.description = data.description.text
			return v
		})
</script>

<Form
	{formData}
	enctype="multipart/form-data"
	submit="Save changes"
	action="?/view&tab=View">
	<Input {formData} name="title" label="Title" />
	<Input
		{formData}
		name="icon"
		label="Place Icon"
		type="file"
		accept="image/*" />
	<hr class="grey-text" />
	<Textarea
		{formData}
		name="description"
		label="Description"
		placeholder="Up to 1000 characters"
		rows="3" />
</Form>
