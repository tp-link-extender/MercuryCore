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

	let tabData = TabData(data.url, ["Daily Stipend"])
</script>

<Head title="Daily Stipend - Admin" />

<div class="container py-6">
	<h1 class="light-text mb-0">Admin - Daily Stipend</h1>
	<a href="/admin" class="text-decoration-none">
		<fa fa-caret-left />
		Back to panel
	</a>
	<div class="row mt-6">
		<div class="col-lg-2 col-md-3 mb-6">
			<TabNav bind:tabData vertical />
		</div>
		<div class="col-lg-10 col-md-9">
			<Tab {tabData}>
				<form use:enhance method="POST" action="?/updateStipend">
					<fieldset>
						<div class="row">
							<label
								for="dailyStipend"
								class="col-md-3 light-text">
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
										<fa fa-gem class="text-success" />
									</span>
								</div>
							</div>
						</div>
						<br />
						<div class="row">
							<label
								for="stipendTime"
								class="col-md-3 light-text">
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
						<button class="btn btn-success">
							{#if $delayed}
								Working...
							{:else}
								Save
							{/if}
						</button>
					</fieldset>
				</form>
				<p
					class:text-success={$page.status == 200}
					class:text-danger={$page.status >= 400}>
					{$message || ""}
				</p>
			</Tab>
		</div>
	</div>
</div>

<style lang="stylus">
	.input-group-text
		border-color var(--accent3)

	.input-group
		max-width 12rem
</style>
