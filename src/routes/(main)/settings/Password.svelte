<script lang="ts">
	import { superForm } from "sveltekit-superforms/client"

	export let data: import("./$types").PageData

	const formData = superForm(data.passwordForm, { taintedMessage: false })
</script>

<Form {formData} action="?/password" submit="Save changes">
	<Input
		{formData}
		name="cpassword"
		label="Current Password"
		type="password"
		placeholder={"•".repeat(14)}
		autocomplete="current-password" />
	<Input
		{formData}
		name="npassword"
		label="New Password"
		type="password"
		autocomplete="new-password"
		placeholder={"•".repeat(20)}
		help="Make sure your password is unique." />
	<Input
		{formData}
		name="cnpassword"
		label="Confirm New Password"
		type="password"
		placeholder={"•".repeat(20)}
		autocomplete="new-password" />
</Form>
