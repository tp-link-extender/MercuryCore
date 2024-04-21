<script lang="ts">
	import { superForm } from "sveltekit-superforms/client"
	import LoginShell from "../LoginShell.svelte"

	export let data
	const formData = superForm(data.form, {
		onResult: ({ result }) =>
			// Reload to get the new session after redirecting to homepage
			result.type === "redirect" ? window.location.reload() : null
	})

	export const snapshot = formData

	const descriptions = [
		[
			"Endless possibilites",
			"Create or play your favourite games and customise your character with items on our catalog."
		],
		[
			"New features",
			"In addition to full client usability, additional features such as security fixes, QoL fixes and an easy to use website make your experience better."
		],
		[
			"Same nostalgia",
			"All of our clients will remain as vanilla as possible, to make sure it's exactly as you remember it."
		]
	]
</script>

<!-- 🌊 WAVES 🌊 DON'T 🌊 DIE 🌊 -->
<!-- <Waves /> -->

<LoginShell {descriptions}>
	{#if data.users}
		<h2>Log into your account</h2>

		<Form {formData} class="pt-6" submit="Log in">
			<Input
				{formData}
				column
				name="username"
				label="Username"
				placeholder="Username" />
			<Input
				{formData}
				column
				name="password"
				label="Password"
				type="password"
				placeholder="Password" />
		</Form>
	{:else}
		<h2>There are no users registered in the database yet!</h2>
		<p class="pt-4">
			Perhaps you've just set up the Mercury 2 source code. Perhaps you've
			already set it up, and something has gone terribly wrong with your
			database.
		</p>
		<p class="pt-2">
			If it's the former, head to this page in a web browser for further
			instructions.
		</p>
	{/if}
</LoginShell>
