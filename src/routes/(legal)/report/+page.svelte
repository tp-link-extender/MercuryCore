<script lang="ts">
	import { enhance } from "$app/forms"

	let fields = {
		category: "",
		note: "",
	}

	export const snapshot = {
		capture: () => fields,
		restore: v => (fields = v),
	}

	export let data
	export let form
</script>

<svelte:head>
	<title>Report {data.user} - Mercury</title>
</svelte:head>

<h1 class="text-center light-text">Report</h1>

<div class="container mt-4 light-text">
	<h2 class="light-text h5">
		Tell us how you think {data.user} is breaking the rules.
	</h2>

	<form use:enhance method="POST" class="mt-4">
		<fieldset>
			<div class="row">
				<label
					for="category"
					class="col-md-3 col-form-label text-md-right">
					Item category
				</label>
				<div class="col-md-8">
					<select
						bind:value={fields.category}
						name="category"
						id="category"
						class="form-select valid"
						required>
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
				</div>
			</div>
			<br />
			<div class="row mb-3">
				<label for="note" class="col-md-3 col-form-label text-md-right">
					Further information
				</label>
				<div class="col-md-8">
					<textarea
						bind:value={fields.note}
						name="note"
						id="note"
						placeholder="Up to 1000 characters"
						required
						class="form-control valid"
						maxlength="1000"
						rows="5" />
				</div>
			</div>
			<br />
			<button type="submit" class="btn btn-success">Submit</button>
		</fieldset>
	</form>
	<br />
	<p class="col-12 mb-3 text-{form?.success ? 'success' : 'danger'}">
		{form?.msg || ""}
	</p>
</div>

<style lang="sass">
	@media only screen and (min-width: 576px)
		.container
			width: 50rem
</style>
