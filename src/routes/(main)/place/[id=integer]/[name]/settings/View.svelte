<script lang="ts">
	import Form from "$lib/components/forms/Form.svelte"
	import Input from "$lib/components/forms/Input.svelte"
	import Textarea from "$lib/components/forms/Textarea.svelte"
	import { get } from "svelte/store"
	import { superForm } from "sveltekit-superforms/client"

	export let data: import("./$types").PageData
	const formData = superForm(data.viewForm)
	const { form } = formData

	if (data.name && !get(formData.form).title) $form.title = data.name
	if (data.description && !get(formData.form).description)
		$form.description = data.description.text
</script>

<Form
	{formData}
	enctype="multipart/form-data"
	submit="<fa fa-save></fa> Save changes"
	action="?/view&tab=View">
	<Input {formData} name="title" label="Title" />
	<Input
		{formData}
		name="icon"
		label="Place icon"
		type="file"
		accept="image/*" />
	<hr class="grey-text" />
	<Textarea
		{formData}
		name="description"
		label="Description"
		placeholder="Up to 1000 characters"
		rows={3} />
</Form>
