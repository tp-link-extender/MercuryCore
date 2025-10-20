<script lang="ts">
	import { superForm } from "sveltekit-superforms/client"
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"
	import Head from "$components/Head.svelte"
	import LoginShell from "../../LoginShell.svelte"
	import Waves from "../../Waves.svelte"

	const { data } = $props()

	const formData = superForm(data.form)
	export const snapshot = formData

	const descriptions: [string, string][] = [
		[
			"Recovery code",
			"Check your email account for the recovery code we sent you."
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
			placeholder="Enter the recovery code" />
	</Form>
</LoginShell>
