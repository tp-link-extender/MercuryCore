<script lang="ts">
	import { superForm } from "sveltekit-superforms/client"
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"

	const { data }: { data: import("./$types").PageData } = $props()

	const formDataPassword = superForm(data.passwordForm)
	const formDataSession = superForm(data.sessionForm)
</script>

<h3 class="text-base pb-4 pt-2">Change password</h3>

<Form
	formData={formDataPassword}
	action="?/password"
	submit="<fa fa-key></fa> Change password">
	<div class="hidden">
		<!-- for accessibility, allows password managers to better autofill etc -->
		<Input
			formData={formDataPassword}
			name="username"
			label="Username"
			type="text"
			autocomplete="username" />
	</div>
	<Input
		formData={formDataPassword}
		name="cpassword"
		label="Current password"
		type="password"
		placeholder={"•".repeat(18)}
		autocomplete="current-password" />
	<Input
		formData={formDataPassword}
		name="npassword"
		label="New password"
		type="password"
		autocomplete="new-password"
		placeholder={"•".repeat(23)}
		help="Make sure your password is unique." />
	<Input
		formData={formDataPassword}
		name="cnpassword"
		label="Confirm new password"
		type="password"
		placeholder={"•".repeat(23)}
		autocomplete="new-password" />
</Form>

<h3 class="text-base pt-6">Sessions</h3>

<p class="grey-text pb-6">
	Invalidate all of your account sessions. <span class="text-red-500">
		This logs you out of {data.siteName} on all browsers and devices.
	</span>
	Use in the event of a security breach.
</p>

<Form
	formData={formDataSession}
	action="?/sessions"
	submit="<fa fa-explosion></fa> Invalidate all sessions">
	<div class="hidden">
		<!-- for accessibility, allows password managers to better autofill etc -->
		<Input
			formData={formDataSession}
			name="username"
			label="Username"
			type="text"
			autocomplete="username" />
	</div>
	<Input
		formData={formDataSession}
		name="password"
		label="Password"
		type="password"
		placeholder={"•".repeat(18)}
		autocomplete="current-password" />
</Form>
