<script lang="ts">
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"
	import { superForm } from "sveltekit-superforms/client"

	interface Props {
		data: import("./$types").PageData;
	}

	let { data }: Props = $props();

	const formData = superForm(data.passwordForm)
</script>

<h3 class="text-base pb-4">Change password</h3>

<Form
	{formData}
	action="?/password"
	submit="<fa fa-key class='pr-2'></fa> Change password">
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
