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

<Head title="Report {data.reportee}" />

<h1 class="text-center light-text">Report</h1>

<div class="container mt-6 light-text">
	<h2 class="light-text fs-5">
		Tell us how you think {data.reportee} is breaking the rules.
	</h2>

	<form use:enhance method="POST" class="mt-6">
		<fieldset>
			<div class="row">
				<label
					for="category"
					class="col-md-3 col-form-label text-md-right">
					Item category
				</label>
				<div class="col-md-8">
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
					<p class="col-12 mb-4 text-danger">
						{$errors.category || ""}
					</p>
				</div>
			</div>
			<br />
			<div class="row mb-4">
				<label for="note" class="col-md-3 col-form-label text-md-right">
					Further information
				</label>
				<div class="col-md-8">
					<textarea
						bind:value={$form.note}
						{...$constraints.note}
						name="note"
						id="note"
						placeholder="Up to 1000 characters"
						class="form-control {$errors.note ? 'is-in' : ''}valid"
						rows="5" />
					<p class="col-12 mb-4 text-danger">
						{$errors.note || ""}
					</p>
				</div>
			</div>
			<button class="btn btn-success">
				{#if $delayed}
					Working...
				{:else}
					Submit
				{/if}
			</button>
		</fieldset>
	</form>
	<p
		class:text-success={$page.status == 200}
		class:text-danger={$page.status >= 400}>
		{$message || ""}
	</p>
</div>

<style lang="stylus">
	containerMinWidth()
</style>
