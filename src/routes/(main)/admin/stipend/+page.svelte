<script lang="ts">
	import { page } from "$app/stores"
	import superForm from "$lib/superForm"

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
	} = superForm(data.form)

	export const snapshot = { capture, restore }

	$form.dailyStipend = data.dailyStipend
	$form.stipendTime = data.stipendTime

	let tabData = TabData(data.url, ["Daily Stipend"])
</script>

<Head title="Daily Stipend - Admin" />

<div class="ctnr py-6">
	<h1 class="mb-0">Admin - Daily Stipend</h1>
	<a href="/admin" class="no-underline">
		<fa fa-caret-left />
		Back to panel
	</a>
	<div class="flex flex-wrap pt-6">
		<TabNav
			bind:tabData
			vertical
			class="w-full lg:w-1/6 md:w-1/4 pb-6 md:pr-4" />
		<div class="w-full lg:w-5/6 md:w-3/4">
			<Tab {tabData}>
				<form use:enhance method="POST" action="?/updateStipend">
					<fieldset>
						<div class="row">
							<label
								for="dailyStipend"
								class="col-md-3 light-text">
								Daily stipend
							</label>
							<div class="col flex items-center">
								<input
									bind:value={$form.dailyStipend}
									{...$constraints.dailyStipend}
									type="number"
									name="dailyStipend"
									id="dailyStipend"
									class="form-control {$errors.dailyStipend
										? 'is-in'
										: ''}valid" />
								<fa fa-gem class="text-success pl-3" />
							</div>
						</div>
						<br />
						<div class="row">
							<label
								for="stipendTime"
								class="col-md-3 light-text">
								Time between stipend
							</label>
							<div class="col flex items-center">
								<input
									bind:value={$form.stipendTime}
									{...$constraints.stipendTime}
									type="number"
									name="stipendTime"
									id="stipendTime"
									class="form-control {$errors.stipendTime
										? 'is-in'
										: ''}valid" />
								<span class="light-text pl-3">hours</span>
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
	input
		max-width 12rem
</style>
