<script lang="ts">
	import type { ActionData, PageData } from "./$types"
	import { enhance } from "$app/forms"

	export let form: ActionData
	export let data: PageData
</script>

<svelte:head>
	<title>Admin - Mercury</title>
</svelte:head>

<h1 class="text-center light-text">Admin panel</h1>

<div class="container mt-5 light-text">
	<h2 class="light-text">Banner</h2>
	<form use:enhance method="POST" action="?/updateBanner">
		<fieldset>
			<div class="row">
				<label for="bannerText" class="col-md-3 col-form-label text-md-right">Banner text</label>
				<div class="col-md-8">
					<input type="text" name="bannerText" id="bannerText" value={data.bannerText} class="form-control valid" />
				</div>
			</div>
			<br />
			<div class="row">
				<label for="bannerColour" class="col-md-3 col-form-label text-md-right">Banner colour</label>
				<div class="col-md-2">
					<input type="color" name="bannerColour" id="bannerColour" value={data.bannerColour} required class="valid" />
				</div>
			</div>
			<br />
			<div class="row">
				<label for="bannerTextLight" class="col-md-3 col-form-label text-md-right">Light text?</label>
				<div class="col-md-2">
					<input type="checkbox" name="bannerTextLight" id="bannerTextLight" value="true" checked={!!data.bannerTextLight} class="valid form-check-input" />
				</div>
			</div>
			<br />
			<button type="submit" class="btn btn-success">Submit</button>
		</fieldset>
	</form>
	<br />
	{#if form?.bannersuccess}
		<p class="col-12 mb-3 text-success">{form?.msg}</p>
	{/if}
	<br />

	<h2 class="light-text">Economy</h2>
	<form use:enhance method="POST" action="?/economy">
		<fieldset>
			<div class="row">
				<label for="taxRate" class="col-md-3 col-form-label text-md-right">Tax rate</label>
				<div class="col-md-8">
					<div class="input-group">
						<input type="number" name="taxRate" id="taxRate" value={data.taxRate} required class="form-control valid" />
						<span class="input-group-text light-text">%</span>
					</div>
				</div>
			</div>
			<br />
			<div class="row">
				<label for="dailyStipend" class="col-md-3 col-form-label text-md-right">Daily stipend</label>
				<div class="col-md-8">
					<div class="input-group">
						<input type="number" name="dailyStipend" id="dailyStipend" value={data.dailyStipend} required class="form-control valid" />
						<span class="input-group-text light-text"><i class="fa fa-gem text-success" /></span>
					</div>
				</div>
			</div>
			<br />
			<div class="row">
				<label for="stipendTime" class="col-md-3 col-form-label text-md-right">Time between stipend</label>
				<div class="col-md-8">
					<div class="input-group">
						<input type="number" name="stipendTime" id="stipendTime" value={data.stipendTime} required class="form-control valid" />
						<span class="input-group-text light-text">hours</span>
					</div>
				</div>
			</div>
			<br />
			<button type="submit" class="btn btn-success">Submit</button>
		</fieldset>
	</form>
	<br />
	{#if form?.economysuccess}
		<p class="col-12 mb-3 text-success">{form?.msg}</p>
	{/if}
	{#if form?.error}
		<p class="col-12 mb-3 text-danger">{form?.msg}</p>
	{/if}
</div>

<style lang="sass">
	@media only screen and (min-width: 576px)
		.container
			width: 50rem

	input[type="color"]
		height: 2.5rem
	input[type="checkbox"]
		height: 1.5rem
		width: 1.5rem

	.input-group-text
		background: var(--accent1)
		border-color: var(--accent3)
</style>
