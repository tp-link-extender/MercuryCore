<script lang="ts">
	import superForm from "$lib/superForm"

	export let data: import("./$types").PageData
	const { user } = data
	const formData = superForm(data.profileForm)
	const { form } = formData

	if (user.bio?.[0]) $form.bio = user.bio[user.bio.length - 1]?.text || ""
</script>

<Form {formData} action="?/profile" submit="Save changes">
	<Select
		{formData}
		name="theme"
		label="Theme"
		disabled
		help="Themes have been disabled while we focus on consolidating the site's design.">
		<option value="standard">Standard</option>
		<option value="darken">Darken</option>
		<option value="storm">Storm</option>
		<option value="solar">Solar</option>
	</Select>

	<hr class="grey-text pb-6" />

	<Textarea
		{formData}
		rows="3"
		name="bio"
		label="Bio"
		placeholder="Maximum 1000 characters"
		help="Your bio will appear on your profile and allow other users to know who you are." />
</Form>
