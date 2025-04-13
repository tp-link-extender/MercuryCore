<script lang="ts">
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"
	import Textarea from "$components/forms/Textarea.svelte"
	import { get } from "svelte/store"
	import { superForm } from "sveltekit-superforms/client"

	interface Props {
		data: import("./$types").PageData;
	}

	let { data }: Props = $props();

	const formData = superForm(data.viewForm)
	const { form } = formData

	if (data.name && !get(formData.form).title) $form.title = data.name
	if (data.description && !get(formData.form).description)
		$form.description = data.description.text
</script>

<Form
	{formData}
	enctype="multipart/form-data"
	submit=" <fa fa-save class='pr-2'></fa> Save changes"
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
