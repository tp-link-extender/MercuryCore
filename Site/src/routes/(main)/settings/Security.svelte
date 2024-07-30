<script lang="ts">
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"
	import fade from "$lib/fade"
	import { superForm } from "sveltekit-superforms/client"

	export let data: import("./$types").PageData

	const formData = superForm(data.passwordForm)

	let copiedSuccess = false
	let value = data.privateKey
</script>

<h3 class="text-base pb-4">Change password</h3>

<Form
	{formData}
	action="?/password"
	submit="<fa fa-key class='pr-2'></fa> Change password">
	<div class="hidden">
		<!-- for accessibility, allows password managers to better autofill etc -->
		<Input
			{formData}
			name="username"
			label="Username"
			type="text"
			autocomplete="username" />
	</div>
	<Input
		{formData}
		name="cpassword"
		label="Current password"
		type="password"
		placeholder={"•".repeat(14)}
		autocomplete="current-password" />
	<Input
		{formData}
		name="npassword"
		label="New password"
		type="password"
		autocomplete="new-password"
		placeholder={"•".repeat(20)}
		help="Make sure your password is unique." />
	<Input
		{formData}
		name="cnpassword"
		label="Confirm new password"
		type="password"
		placeholder={"•".repeat(20)}
		autocomplete="new-password" />
</Form>

<hr />

<h3 class="text-base pb-4">Account assets</h3>

<div class="flex flex-wrap pb-2">
	<label for="privateKey" class="w-full md:w-1/4">Private key</label>
	<div class="w-full md:w-3/4">
		<div class="input-group">
			<input id="privateKey" type="password" {value} disabled />
			<button
				on:click={() => {
					navigator.clipboard.writeText(value)
					copiedSuccess = true
					setTimeout(() => (copiedSuccess = false), 4000)
				}}
				class="btn btn-tertiary border-[--accent2] border-l-0"
				type="button">
				<fa fa-copy />
			</button>
		</div>
		{#if copiedSuccess}
			<small
				id="copiedSuccess"
				transition:fade
				class="block text-yellow-5">
				Successfully copied key to clipboard. Store in a cool, dry
				place.
			</small>
		{/if}

		<small class="formhelp">
			Your private key can be used to access your account's assets outside
			of Mercury or in the event of Mercury shutting down, via the
			blockchain. {data.currencySymbol} are stored as Fungible Tokens (FTs)
			and assets are stored as Non-Fungible Tokens (NFTs).
			<br />
			<span class="text-red-5">
				Do not share this key with anyone! Mercury administrators will
				never ask for it.
			</span>
		</small>
	</div>
</div>
