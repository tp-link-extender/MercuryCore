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

	const descriptions: [string, string][] = [
		[
			"Account recovery",
			"Enter your email address and we'll send you instructions to access your account."
		]
	]
</script>

<Head
	name={data.siteName}
	title="Account recovery"
	description="Recover your {data.siteName} account." />

<Waves reverse />

<LoginShell name={data.siteName} tagline={data.tagline} {descriptions} pad>
	<h2>Recover your account</h2>
	<p>
		Don't yet have an account?
		<a href="/register" class="no-underline">Register</a>
	</p>

	<Form {formData} class="pt-6" submit="Send recovery email">
		<Input
			{formData}
			column
			autocomplete="email"
			name="email"
			label="Email address"
			placeholder="{data.siteName}@{data.domain}" />
	</Form>
</LoginShell>
