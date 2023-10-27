<script lang="ts">
	import { page } from "$app/stores"
	import { superForm } from "sveltekit-superforms/client"

	export let data: import("./$types").PageData
	const { user } = data

	const { form, errors, message, constraints, enhance, delayed } = superForm(
		data.profileForm,
		{ taintedMessage: false }
	)

	if (user.theme) $form.theme = user.theme as typeof $form.theme
	if (user.bio?.[0]) $form.bio = user.bio[0].text
</script>

<form use:enhance method="POST" class="col-lg-8" action="?a=profile">
	<fieldset class="pb-2">
		<div class="row">
			<label for="theme" class="col-md-3 text-md-right">Theme</label>
			<div class="col-md-8">
				<select
					bind:value={$form.theme}
					{...$constraints.theme}
					id="theme"
					name="theme"
					class="form-select {$errors.theme ? 'is-in' : ''}valid">
					<option value="standard">Standard</option>
					<option value="darken">Darken</option>
					<option value="storm">Storm</option>
					<option value="solar">Solar</option>
				</select>
				<p class="col-12 text-danger">
					{$errors.theme || ""}
				</p>
			</div>
		</div>
		<hr class="grey-text" />
		<div class="row">
			<label for="bio" class="light-text">Bio</label>
			<div class="container">
				<textarea
					bind:value={$form.bio}
					{...$constraints.bio}
					class="form-control light-text bg-a {$errors.bio
						? 'is-in'
						: ''}valid"
					id="bio"
					name="bio"
					rows="3" />
				<small class="grey-text">
					Maximum 1000 characters, your bio will appear on your
					profile and allow other users to know who you are.
				</small>
				<p class="col-12 text-danger">
					{$errors.bio || ""}
				</p>
			</div>
		</div>
	</fieldset>
	<button
		class="btn btn-success"
		on:click={() => {
			// Reload page to ensure theme is applied correctly
			if (user.theme != $form.theme) window.location.reload()
		}}>
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
