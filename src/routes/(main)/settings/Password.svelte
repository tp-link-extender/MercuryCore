<script lang="ts">
	import Form from "$lib/components/forms/Form.svelte"
	import Input from "$lib/components/forms/Input.svelte"
	import { superForm } from "sveltekit-superforms/client"

	export let data: import("./$types").PageData
	const formData = superForm(data.passwordForm)
</script>

<Form
	{formData}
	action="?/password"
	submit="<far fa-key></far> Change password">
	<div class="hidden">
		<!-- for accessibility, allows password managers to better autofill etc -->
		<Input
			{formData}
			name="username"
			label="Username"
			type="text"
			autocomplete="username" />
	</div>
	<Input
		{formData}
		name="cpassword"
		label="Current password"
		type="password"
		placeholder={"•".repeat(14)}
		autocomplete="current-password" />
	<Input
		{formData}
		name="npassword"
		label="New password"
		type="password"
		autocomplete="new-password"
		placeholder={"•".repeat(20)}
		help="Make sure your password is unique." />
	<Input
		{formData}
		name="cnpassword"
		label="Confirm new password"
		type="password"
		placeholder={"•".repeat(20)}
		autocomplete="new-password" />
</Form>
