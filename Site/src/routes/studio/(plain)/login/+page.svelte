<script lang="ts">
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"
	import { superForm } from "sveltekit-superforms/client"

	const { data } = $props()

	const formData = superForm(data.form)
</script>

<div class="container mx-auto w-100 pb-8 pt-16">
	<div class="hero-text pb-8 pt-16">
		<h1>Log in to Mercury Studio</h1>
		<small>
			Log in to Mercury Studio to create or update your places! <br />
			Don't have an account? Register one!
		</small>
	</div>
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
	</Form>
</div>

<style>
	a {
		text-decoration: none;
		color: #8b52f0;
	}
	.hero-text {
		text-align: center;
	}
	button {
		width: 100%;
	}
</style>
