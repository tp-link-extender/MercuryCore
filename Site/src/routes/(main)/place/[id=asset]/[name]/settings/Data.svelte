<script lang="ts">
	import { get } from "svelte/store"
	import { superForm } from "sveltekit-superforms/client"
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"

	const { data }: { data: import("./$types").PageData } = $props()

	const formData = superForm(data.viewForm)
	const { form } = formData
</script>

<Form
	{formData}
	enctype="multipart/form-data"
	submit=" <fa fa-save></fa> Save changes"
	action="?/data&tab=Data">
	<Input
		{formData}
		name="file"
		label="Place file"
		type="file"
		accept=".rbxl" />
</Form>
