<script lang="ts">
	import Form from "#components/forms/Form.svelte"
	import Input from "#components/forms/Input.svelte"
	import { privacyForm } from "./settings.remote.js"

	const { data }: { data: import("./$types").PageData } = $props()

	const privacyFormFor = privacyForm.for(data.id)
</script>

<Form formData={privacyFormFor} submit=" <fa fa-save></fa> Save changes">
	<Input
		formData={privacyFormFor}
		name="privateServer"
		label="Private server"
		type="checkbox"
		defaultValue={data.privateServer} />
</Form>
