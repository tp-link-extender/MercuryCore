<script lang="ts">
	import Form from "$components/forms/Form.svelte"
	import Select from "$components/forms/Select.svelte"
	import Textarea from "$components/forms/Textarea.svelte"
	import { superForm } from "sveltekit-superforms/client"

	const { data }: { data: import("./$types").PageData } = $props()

	const { user } = data
	const formData = superForm(data.profileForm)
	const { form } = formData

	const themes: [string, string][] = data.themes.map((theme, i) => [
		i.toString(),
		theme
	])

	$effect(() => {
		if (user.description) $form.description = user.description.text || ""
	})
</script>

<Form {formData} action="?/profile" submit="<fa fa-save></fa> Save changes">
	<Select
		{formData}
		options={themes}
		selected={user.theme.toString()}
		name="theme"
		label="Theme" />

	<hr class="grey-text pb-6" />

	<Textarea
		{formData}
		name="description"
		label="Description"
		placeholder="Maximum 1000 characters"
		help="Your description will appear on your profile and allow other users to know who you are.<br />Don't put any personally identifiable information here. It's the internet, and the ORC no less. You know the deal."
		rows={3} />
</Form>
