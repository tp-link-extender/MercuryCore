<script lang="ts">
	import Head from "$components/Head.svelte"
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"
	import { superForm } from "sveltekit-superforms/client"
	import LoginShell from "../LoginShell.svelte"
	import Waves from "../Waves.svelte"

	export let data

	const formData = superForm(data.form)
	export const snapshot = formData

	const descriptions = [
		[
			"Original username",
			"Make sure it is appropriate and between 3-21 characters. Underscores are allowed."
		],
		[
			"Valid email",
			`${data.siteName} requires a valid email so you can reset your password at any time.`
		],
		[
			"Secure password",
			"Make sure your password has a mix of letters, numbers, and symbols to protect against hackers."
		]
	]
</script>

<Head
	name={data.siteName}
	title="Register"
	description="Create a {data.siteName} account." />

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
				placeholder="{data.siteName}@{data.domain}" />
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
	{:else}
		<h2>Create the initial account</h2>

		<p class="pt-2">
			This will be the first user account on this Mercury Core instance!
		</p>
		<p>
			It will automatically have the highest permission level. It will not
			have any other special properties like infinite currency or
			whatever.
		</p>
		<p>
			Pick the username and password carefully, and good luck on your
			journey with Mercury Core!
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
