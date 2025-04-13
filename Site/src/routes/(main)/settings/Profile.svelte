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

	if (user.bio) $form.bio = user.bio.text || ""
</script>

<Form
	{formData}
	action="?/profile"
	submit="<fa fa-save class='pr-2'></fa> Save changes">
	<Select
		{formData}
		options={themes}
		selected={user.theme.toString()}
		name="theme"
		label="Theme" />

	<hr class="grey-text pb-6" />

	<Textarea
		{formData}
		name="bio"
		label="Bio"
		placeholder="Maximum 1000 characters"
		help="Your bio will appear on your profile and allow other users to know who you are."
		rows={3} />
</Form>
