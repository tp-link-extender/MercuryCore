<script lang="ts">
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"
	import Head from "$components/Head.svelte"
	import { superForm } from "$lib/validate"
	import LoginShell from "../LoginShell.svelte"
	import Waves from "../Waves.svelte"

	const { data } = $props()

	let formData = $derived(superForm(data.form))
	export const snapshot = formData
</script>

<Head
	name={data.siteName}
	title="Log in"
	description="Log into your {data.siteName} account." />

<Waves reverse />

<LoginShell
	name={data.siteName}
	tagline={data.tagline}
	descriptions={data.descriptions}
	pad>
	{#if data.users}
		<h2>Log into your account</h2>
		<p>
			Don't yet have an account?
			<a href="/register" class="no-underline">Register</a>
		</p>

		<Form {formData} class="pt-6" submit="Log in">
			<Input
				{formData}
				column
				autocomplete="username"
				name="username"
				label="Username"
				placeholder="Username" />
			<Input
				{formData}
				column
				autocomplete="current-password"
				name="password"
				label="Password"
				type="password"
				placeholder={"•".repeat(18)} />

			<p>
				Forgotten your password?
				<a href="/recover" class="no-underline">Recover</a>
			</p>
		</Form>
	{:else}
		<h2>There are no users registered in the database yet!</h2>
		<p class="pt-4">
			Perhaps you've just set up Mercury Core. Perhaps you've already set
			it up before, and something has gone terribly wrong with your
			database.
		</p>
		<p class="pt-2">
			If it's the former, head to the
			<a href="/register" class="no-underline">Register</a>
			page to create the first user!
		</p>
	{/if}
</LoginShell>
