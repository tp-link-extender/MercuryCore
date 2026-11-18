<script lang="ts">
	import Form from "#components/forms/Form.svelte"
	import Select from "#components/forms/Select.svelte"
	import Textarea from "#components/forms/Textarea.svelte"
	import { profileForm } from "./settings.remote.js"

	const { data }: { data: import("./$types").PageData } = $props()

	let { user } = $derived(data)
</script>

<Form formData={profileForm} submit="<fa fa-save></fa> Save changes">
	<Select
		formData={profileForm}
		options={Object.values(data.themes)}
		selected={data.themes[user.theme]}
		name="theme"
		label="Theme" />

	<hr class="grey-text pb-6" />

	<Textarea
		formData={profileForm}
		name="description"
		defaultValue={user.description || ""}
		label="Description"
		placeholder="Maximum 1000 characters"
		help="Your description will appear on your profile and allow other users to know who you are.<br />Don't put any personally identifiable information here. It's the internet, and the ORC no less. You know the deal."
		rows={3} />
</Form>
