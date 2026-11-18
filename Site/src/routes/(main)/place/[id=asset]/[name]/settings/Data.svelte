<script lang="ts">
	import Form from "#components/forms/Form.svelte"
	import Input from "#components/forms/Input.svelte"
	import { dataForm } from "./settings.remote.js"

	const { data }: { data: import("./$types").PageData } = $props()

	const dataFormFor = dataForm.for(data.id)
</script>

<Form
	formData={dataFormFor}
	enctype="multipart/form-data"
	submit=" <fa fa-save></fa> Save changes">
	<Input
		formData={dataFormFor}
		name="file"
		label="Place file"
		type="file"
		accept=".rbxl" />
</Form>
