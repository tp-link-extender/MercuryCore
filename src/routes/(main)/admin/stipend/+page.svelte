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

	$form.dailyStipend = data.dailyStipend
	$form.stipendTime = data.stipendTime
</script>

<svelte:head>
	<title>Admin - Mercury</title>
</svelte:head>

<div class="container py-4">
	<h1 class="light-text mb-0">Admin - Daily Stipend</h1>
	<a href="/admin" class="text-decoration-none">
		<i class="fas fa-caret-left" />
		Back to panel
	</a>
	<div class="row mt-4">
		<div class="col-lg-2 col-md-3 mb-4">
			<ul class="nav nav-tabs flex-column border-0">
				<li class="nav-item" role="presentation">
					<a
						class="nav-link active"
						data-bs-toggle="tab"
						href="#dailyStipend"
						aria-selected="true"
						role="tab">
						Daily Stipend
					</a>
				</li>
			</ul>
		</div>
		<div class="col-lg-10 col-md-9">
			<div id="myTabContent" class="tab-content">
				<div
					class="tab-pane fade active show"
					id="dailyStipend"
					role="tabpanel">
					<form use:enhance method="POST" action="?/updateStipend">
						<fieldset>
							<div class="row">
								<label
									for="dailyStipend"
									class="col-md-3 col-form-label light-text">
									Daily stipend
								</label>
								<div class="col-md-8">
									<div class="input-group">
										<input
											bind:value={$form.dailyStipend}
											{...$constraints.dailyStipend}
											type="number"
											name="dailyStipend"
											id="dailyStipend"
											class="form-control {$errors.dailyStipend
												? 'is-in'
												: ''}valid" />
										<span
											class="input-group-text light-text bg-a1">
											<i class="fa fa-gem text-success" />
										</span>
									</div>
								</div>
							</div>
							<br />
							<div class="row">
								<label
									for="stipendTime"
									class="col-md-3 col-form-label light-text">
									Time between stipend
								</label>
								<div class="col-md-8">
									<div class="input-group">
										<input
											bind:value={$form.stipendTime}
											{...$constraints.stipendTime}
											type="number"
											name="stipendTime"
											id="stipendTime"
											class="form-control {$errors.stipendTime
												? 'is-in'
												: ''}valid" />
										<span
											class="input-group-text light-text bg-a1">
											hours
										</span>
									</div>
								</div>
							</div>
							<br />
							<button type="submit" class="btn btn-success">
								Submit
							</button>
						</fieldset>
					</form>
					<p
						class:text-success={$page.status == 200}
						class:text-danger={$page.status >= 400}>
						{$message || ""}
					</p>
				</div>
			</div>
		</div>
	</div>
</div>

<style lang="sass">

	.nav-tabs .nav-item.show .nav-link,
	.nav-tabs .nav-link.active 
		color: rgb(255, 255, 255)
		background-color: rgb(13, 109, 252)
		border-color: var(--bs-nav-tabs-link-active-border-color)
		border-radius: 0.375rem
		
	.nav-tabs .nav-link 
		margin-bottom: calc(0 * var(--bs-nav-tabs-border-width))
		background: 0 0
		border: var(--bs-nav-tabs-border-width) solid transparent
		border-radius: 0.375rem

	.nav-link
		border-radius: 0
		color: var(--light-text)

	.input-group-text
		border-color: var(--accent3)

	.input-group
		max-width: 12rem
</style>
