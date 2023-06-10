<script lang="ts">
	import { page } from "$app/stores"
	import { superForm } from "sveltekit-superforms/client"
	import { Tab, TabNav, TabData } from "$lib/components/Tabs"

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

<svelte:head>
	<title>Admin - Mercury</title>
</svelte:head>

<div class="container py-4">
	<h1 class="light-text mb-0">Admin - Daily Stipend</h1>
	<a href="/admin" class="no-underline">
		<i class="fas fa-caret-left" />
		Back to panel
	</a>
	<div class="grid grid-cols-12 gap-6 mt-4">
		<div class="lg:col-span-2 md:col-span-3 mb-4">
			<TabNav bind:tabData tabs />
		</div>
		<div class="lg:col-span-10 md:col-span-9">
			<Tab {tabData}>
				<form use:enhance method="POST" action="?/updateStipend">
					<fieldset>
						<div class="grid grid-cols-12 gap-6">
							<label
								for="dailyStipend"
								class="md:col-span-3 col-form-label light-text">
								Daily stipend
							</label>
							<div class="md:col-span-8">
								<div class="flex">
									<input
										bind:value={$form.dailyStipend}
										{...$constraints.dailyStipend}
										type="number"
										name="dailyStipend"
										id="dailyStipend"
										class="form-control {$errors.dailyStipend
											? 'is-in'
											: ''}valid" />
									<span class="flex-text light-text bg-a1">
										<i class="fa fa-gem text-emerald-500" />
									</span>
								</div>
							</div>
						</div>
						<br />
						<div class="grid grid-cols-12 gap-6">
							<label
								for="stipendTime"
								class="md:col-span-3 col-form-label light-text">
								Time between stipend
							</label>
							<div class="md:col-span-8">
								<div class="flex">
									<input
										bind:value={$form.stipendTime}
										{...$constraints.stipendTime}
										type="number"
										name="stipendTime"
										id="stipendTime"
										class="form-control {$errors.stipendTime
											? 'is-in'
											: ''}valid" />
									<span class="flex-text light-text bg-a1">
										hours
									</span>
								</div>
							</div>
						</div>
						<br />
						<button
							type="submit"
							class="btn bg-emerald-600 hover:bg-emerald-800 text-white">
							Submit
						</button>
					</fieldset>
				</form>
				<p
					class:text-emerald-500={$page.status == 200}
					class:text-red-500={$page.status >= 400}>
					{$message || ""}
				</p>
			</Tab>
		</div>
	</div>
</div>

<style lang="sass">
	.input-group-text
		border-color: var(--accent3)

	.input-group
		max-width: 12rem
</style>
