<script lang="ts">
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"
	import Textarea from "$components/forms/Textarea.svelte"
	import { get } from "svelte/store"
	import { superForm } from "sveltekit-superforms/client"

	const { data }: { data: import("./$types").PageData } = $props()

	const formData = superForm(data.viewForm)
	const { form } = formData

	$effect(() => {
		if (data.description && !get(formData.form).description)
			$form.description = data.description.text
	})
</script>

<Form
	{formData}
	enctype="multipart/form-data"
	submit=" <fa fa-save></fa> Save changes"
	action="?/view&tab=View">
	<Input {formData} name="name" label="Name" />
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
