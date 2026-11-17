<script lang="ts">
	import Form from "#components/forms/Form.svelte"
	import Input from "#components/forms/Input.svelte"
	import Textarea from "#components/forms/Textarea.svelte"
	import { viewForm } from "./settings.remote.js"

	const { data }: { data: import("./$types").PageData } = $props()

	const viewFormFor = viewForm.for(data.id)
</script>

<Form
	formData={viewFormFor}
	enctype="multipart/form-data"
	submit=" <fa fa-save></fa> Save changes">
	<Input
		formData={viewFormFor}
		name="name"
		label="Name"
		defaultValue={data.name} />
	<Input
		formData={viewFormFor}
		name="icon"
		label="Place icon"
		type="file"
		accept="image/*" />

	<hr class="grey-text pb-6" />

	<Textarea
		formData={viewFormFor}
		name="description"
		label="Description"
		defaultValue={data.description}
		placeholder="Up to 1000 characters"
		rows={3} />
</Form>
