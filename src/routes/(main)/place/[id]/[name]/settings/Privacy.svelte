<script lang="ts">
	import superForm from "$lib/superForm"

	export let data: import("./$types").PageData
	const formData = superForm(data.privacyForm)

	if (data.privateServer)
		formData.form.update(v => {
			v.privateServer = data.privateServer
			return v
		})
</script>

<Form {formData} submit="Save changes" action="?/privacy&tab=Privacy">
	<Input
		{formData}
		name="privateServer"
		label="Private Server"
		type="checkbox" />
</Form>
