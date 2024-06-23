<script lang="ts">
	import Form from "$lib/components/forms/Form.svelte"
	import Input from "$lib/components/forms/Input.svelte"
	import { superForm } from "sveltekit-superforms/client"
	import LoginShell from "../LoginShell.svelte"
	import Waves from "../Waves.svelte"

	export let data
	const formData = superForm(data.form, {
		onResult: ({ result }) =>
			// Reload to get the new session after redirecting to homepage
			result.type === "redirect" ? window.location.reload() : null
	})

	export const snapshot = formData

	const descriptions = [
		[
			"Original username",
			"Make sure it is appropriate and between 3-21 characters. Underscores are allowed."
		],
		[
			"Valid email",
			"Mercury requires a valid email so you can reset your password at any time."
		],
		[
			"Secure password",
			"Make sure your password has a mix of letters, numbers, and symbols to protect against hackers."
		]
	]
</script>

<Head title="Register" description="Create a Mercury account." />

<Waves />

<LoginShell {descriptions}>
	{#if data.users}
		<h2>Create a free account</h2>
		<p>
			Already have an account?
			<a href="/login" class="no-underline">Log in</a>
		</p>

		<Form {formData} action="?/register" class="pt-6" submit="Register">
			<Input
				{formData}
				column
				autocomplete="username"
				name="username"
				label="Username"
				placeholder="3-21 characters" />
			<Input
				{formData}
				column
				autocomplete="email"
				name="email"
				label="Email Address"
				type="email"
				placeholder="Mercury@{data.domain}" />
			<Input
				{formData}
				column
				autocomplete="new-password"
				name="password"
				label="Password"
				type="password"
				placeholder={"•".repeat(14)} />
			<Input
				{formData}
				column
				autocomplete="new-password"
				name="cpassword"
				label="Confirm Password"
				type="password"
				placeholder={"•".repeat(14)} />
			<Input
				{formData}
				column
				name="regkey"
				label="Registration Key"
				placeholder="mercurkey-12311121123" />
		</Form>

		<p>
			By signing up, you agree to our Terms of Service and Privacy Policy.
		</p>
	{:else}
		<h2>Create the initial account</h2>

		<p class="pt-2">
			This will be the first user account on this Mercury instance!
		</p>
		<p>
			It will have all permissions, and will be the destination for all
			transactions that aren't sent to a specific user. It will be
			initialised with a balance of
			<span class="text-emerald-6">
				<fa fa-gem />
				999999
			</span>
			, which will not increase or decrease when transactions are made to or
			from the account.
		</p>
		<p>
			Pick the username and password carefully, and good luck on your
			journey with Mercury!
		</p>

		<Form
			{formData}
			action="?/initialAccount"
			class="pt-6"
			submit="Let's begin!">
			<Input
				{formData}
				column
				name="username"
				label="Username"
				placeholder="3-21 characters" />
			<Input
				{formData}
				column
				name="password"
				label="Password"
				type="password"
				placeholder={"•".repeat(14)} />
			<Input
				{formData}
				column
				name="cpassword"
				label="Confirm Password"
				type="password"
				placeholder={"•".repeat(14)} />
		</Form>
		<p>
			If you want to create more users, head to the Admin panel after
			logging in to create some registration keys, then come back to this
			page.
		</p>
	{/if}
</LoginShell>
