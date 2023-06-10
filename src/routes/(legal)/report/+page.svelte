<script lang="ts">
	import { page } from "$app/stores"
	import { superForm } from "sveltekit-superforms/client"

	export let data
	const {
		form,
		errors,
		message,
		constraints,
		enhance,
		delayed,
		capture,
		restore,
	} = superForm(data.form, {
		taintedMessage: false,
	})

	export const snapshot = { capture, restore }
</script>

<svelte:head>
	<title>Report {data.reportee} - Mercury</title>
</svelte:head>

<h1 class="text-center light-text">Report</h1>

<div class="container mt-4 light-text">
	<h2 class="light-text h5">
		Tell us how you think {data.reportee} is breaking the rules.
	</h2>

	<form use:enhance method="POST" class="mt-4">
		<fieldset>
			<div class="grid grid-cols-12 gap-6">
				<label
					for="category"
					class="md:col-span-3 col-form-label text-md-right">
					Item category
				</label>
				<div class="md:col-span-8">
					<select
						bind:value={$form.category}
						{...$constraints.category}
						name="category"
						id="category"
						class="form-select {$errors.category
							? 'is-in'
							: ''}valid">
						<option value="AccountTheft">Account theft</option>
						<option value="Dating">Dating</option>
						<option value="Exploiting">Exploiting</option>
						<option value="Harassment">
							Harassment or discrimination
						</option>
						<option value="InappropriateContent">
							Inappropriate content
						</option>
						<option value="PersonalInformation">
							Personal information (displaying their own or asking
							for others')
						</option>
						<option value="Scamming">Scamming</option>
						<option value="Under13">Suspected under 13 user</option>
						<option value="Spam">Spam</option>
						<option value="Swearing">Swearing</option>
						<option value="Threats">Threats</option>
					</select>
					<p class="col-span-12 mb-3 text-red-500">
						{$errors.category || ""}
					</p>
				</div>
			</div>
			<br />
			<div class="grid grid-cols-12 gap-6 mb-3">
				<label
					for="note"
					class="md:col-span-3 col-form-label text-md-right">
					Further information
				</label>
				<div class="md:col-span-8">
					<textarea
						bind:value={$form.note}
						{...$constraints.note}
						name="note"
						id="note"
						placeholder="Up to 1000 characters"
						class="form-control {$errors.note ? 'is-in' : ''}valid"
						rows="5" />
					<p class="col-span-12 mb-3 text-red-500">
						{$errors.note || ""}
					</p>
				</div>
			</div>
			<button
				type="submit"
				class="btn bg-emerald-600 hover:bg-emerald-800 text-white">
				{#if $delayed}
					Working...
				{:else}
					Submit
				{/if}
			</button>
		</fieldset>
	</form>
	<p
		class:text-emerald-500={$page.status == 200}
		class:text-red-500={$page.status >= 400}>
		{$message || ""}
	</p>
</div>

<style lang="sass">
	@media only screen and (min-width: 576px)
		.container
			width: 50rem
</style>
