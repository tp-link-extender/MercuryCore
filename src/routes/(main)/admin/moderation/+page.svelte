<script lang="ts">
	import fade from "$lib/fade"
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

	const tomorrow = new Date(Date.now() + 86400000).toISOString().slice(0, 10)

	let tabData = TabData(data.url, ["Moderate User"])
</script>

<svelte:head>
	<title>Admin - Mercury</title>
</svelte:head>

<div class="container py-4">
	<h1 class="light-text mb-0">Admin - Moderate User</h1>
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
				<form use:enhance method="POST" action="?/moderateUser">
					<fieldset>
						<div class="grid grid-cols-12 gap-6">
							<label
								for="username"
								class="md:col-span-3 col-form-label light-text">
								Username
							</label>
							<div class="md:col-span-8">
								<input
									bind:value={$form.username}
									{...$constraints.username}
									type="text"
									name="username"
									id="username"
									class="form-control {$errors.username
										? 'is-in'
										: ''}valid" />
								<p class="col-span-12 text-red-500">
									{$errors.username || ""}
								</p>
							</div>
						</div>
						<div class="grid grid-cols-12 gap-6">
							<label
								for="action"
								class="md:col-span-3 col-form-label light-text">
								Action
							</label>
							<div class="md:col-span-8">
								<select
									bind:value={$form.action}
									{...$constraints.action}
									name="action"
									id="action"
									class="form-control light-text {$errors.action
										? 'is-in'
										: ''}valid">
									<option value="1" selected>Warning</option>
									<option value="2">Ban</option>
									<option value="3">Termination</option>
									<option value="4">Account Deletion</option>
									<option value="5">Unban</option>
								</select>
								<p class="col-span-12 text-red-500">
									{$errors.action || ""}
								</p>
							</div>
						</div>
						{#if $form.action == 2}
							<div
								class="grid grid-cols-12 gap-6"
								transition:fade>
								<label
									for="banDate"
									class="md:col-span-3 col-form-label light-text">
									Ban until
								</label>
								<div class="md:col-span-8">
									<input
										bind:value={$form.banDate}
										{...$constraints.banDate}
										type="date"
										name="banDate"
										id="banDate"
										min={tomorrow}
										required
										class="form-control {$errors.banDate
											? 'is-in'
											: ''}valid" />
									<p class="col-span-12 text-red-500">
										{$errors.banDate || ""}
									</p>
								</div>
							</div>
						{/if}
						<div class="grid grid-cols-12 gap-6">
							<label
								for="reason"
								class="md:col-span-3 col-form-label light-text">
								Reason
							</label>
							<div class="md:col-span-8">
								<textarea
									bind:value={$form.reason}
									{...$constraints.reason}
									name="reason"
									id="reason"
									class="form-control {$errors.reason
										? 'is-in'
										: ''}valid" />
								<p class="col-span-12 text-red-500">
									{$errors.reason || ""}
								</p>
							</div>
						</div>
						<button
							type="submit"
							class="btn bg-emerald-600 hover:bg-emerald-800 text-white mt-3">
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
			</Tab>
		</div>
	</div>
</div>
