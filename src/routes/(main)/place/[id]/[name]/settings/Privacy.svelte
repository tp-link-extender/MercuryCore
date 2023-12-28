<script lang="ts">
	import superForm from "$lib/superForm"

	export let data: import("./$types").PageData
	const formData = superForm(data.privacyForm)
	const { form } = formData

	if (data.privateServer) $form.privateServer = data.privateServer
</script>

<Form {formData} submit="Save changes" action="?/privacy&tab=Privacy">
	<Input
		{formData}
		name="privateServer"
		label="Private Server"
		type="checkbox" />
</Form>
