<script lang="ts">
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"
	import { superForm } from "$lib/validate"

	const { data }: { data: import("./$types").PageData } = $props()

	let formData = $derived(superForm(data.viewForm))
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
