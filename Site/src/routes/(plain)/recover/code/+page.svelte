<script lang="ts">
	import { superForm } from "sveltekit-superforms/client"
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"
	import Head from "$components/Head.svelte"
	import LoginShell from "../../LoginShell.svelte"
	import Waves from "../../Waves.svelte"

	const { data } = $props()

	let formData = $derived(superForm(data.form))
	export const snapshot = formData

	const descriptions: [string, string][] = [
		[
			"Recovery code",
			"If this email address is associated with an account, you should have received a recovery code. Enter it to access your account."
		],
		[
			"Password reset",
			"You'll also need to enter a new password so you can securely access your account again."
		],
		[
			"Didn't receive an email?",
			"Check your spam folder or try resubmitting your email address to receive a new recovery code."
		]
	]
</script>

<Head
	name={data.siteName}
	title="Account recovery"
	description="Recover your {data.siteName} account." />

<Waves reverse />

<LoginShell name={data.siteName} tagline={data.tagline} {descriptions} pad>
	<h2>Enter recovery code</h2>
	<p>
		Didn't receive an email?
		<a href="/recover" class="no-underline">Try again</a>
	</p>

	<Form {formData} class="pt-6" submit="Log in">
		<Input
			{formData}
			column
			autocomplete="one-time-code"
			name="code"
			label="Recovery code"
			placeholder="R3c0v4" />
		<Input
			{formData}
			column
			name="npassword"
			label="New password"
			type="password"
			autocomplete="new-password"
			placeholder={"•".repeat(23)}
			help="Make sure your new password is unique." />
		<Input
			{formData}
			column
			name="cnpassword"
			label="Confirm new password"
			type="password"
			placeholder={"•".repeat(23)}
			autocomplete="new-password" />
	</Form>
</LoginShell>
