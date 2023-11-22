<script lang="ts">
	import { page } from "$app/stores"
	import { superForm } from "sveltekit-superforms/client"

	export let data: import("./$types").PageData

	const { form, errors, message, constraints, enhance, delayed } = superForm(
		data.passwordForm,
		{ taintedMessage: false }
	)
</script>

<form use:enhance method="POST" class="col-sm-8" action="?/password">
	<fieldset class="pb-2">
		<label for="password" class="col-sm-4">Current Password</label>
		<div class="col-sm-10">
			<input
				bind:value={$form.cpassword}
				{...$constraints.cpassword}
				type="password"
				autocomplete="current-password"
				class="form-control light-text {$errors.cpassword
					? 'is-in'
					: ''}valid"
				id="cpassword"
				name="cpassword" />
			<p class="col-12 text-danger">
				{$errors.cpassword || ""}
			</p>
		</div>
		<label for="npassword" class="col-sm-4">New Password</label>
		<div class="col-sm-10">
			<input
				bind:value={$form.npassword}
				{...$constraints.npassword}
				type="password"
				autocomplete="new-password"
				class="form-control light-text {$errors.npassword
					? 'is-in'
					: ''}valid"
				id="npassword"
				name="npassword" />
			<small class="grey-text">Make sure your password is unique.</small>
			<p class="col-12 text-danger">
				{$errors.npassword || ""}
			</p>
		</div>
		<label for="cnpassword" class="col-sm-4">Confirm New Password</label>
		<div class="col-sm-10">
			<input
				bind:value={$form.cnpassword}
				{...$constraints.cnpassword}
				type="password"
				autocomplete="new-password"
				class="form-control light-text {$errors.cnpassword
					? 'is-in'
					: ''}valid"
				id="cnpassword"
				name="cnpassword" />
			<p class="col-12 text-danger">
				{$errors.cnpassword || ""}
			</p>
		</div>
	</fieldset>
	<button class="btn btn-success">
		{#if $delayed}
			Working...
		{:else}
			Save changes
		{/if}
	</button>
	<p
		class:text-success={$page.status == 200}
		class:text-danger={$page.status >= 400}>
		{$message || ""}
	</p>
</form>
