<script lang="ts">
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"
	import Head from "$components/Head.svelte"
	import { superForm } from "$lib/validate"
	import LoginShell from "../../LoginShell.svelte"
	import Waves from "../../Waves.svelte"

	const { data } = $props()

	let formData = $derived(superForm(data.form))
	export const snapshot = formData

	const descriptions: [string, string][] = [
		[
			"Password reset",
			"Enter a new password to access your account again. You'll be logged out everywhere else."
		],
		[
			"Link not working?",
			"Recovery links are valid for 1 hour and can only be used once. Requesting a new link makes any older ones stop working."
		]
	]
</script>

<Head
	name={data.siteName}
	title="Account recovery"
	description="Recover your {data.siteName} account." />

<Waves reverse />

<LoginShell name={data.siteName} tagline={data.tagline} {descriptions} pad>
	{#if data.valid}
		<h2>Reset your password</h2>
		<p>
			Link not working?
			<a href="/recover" class="no-underline">Request a new one</a>
		</p>

		<Form {formData} class="pt-6" submit="Reset password and log in">
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
	{:else}
		<h2>Link invalid or expired</h2>
		<p class="pt-4">
			This recovery link has already been used, has expired, or was replaced
			by a newer one. Recovery links are valid for 1 hour.
		</p>
		<p>
			<a href="/recover" class="no-underline">Request a new recovery link</a>
		</p>
	{/if}
</LoginShell>
