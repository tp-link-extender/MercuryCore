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

	let tabData = TabData(data.url, ["Reset User Password"])
</script>

<svelte:head>
	<title>Admin - Mercury</title>
</svelte:head>

<div class="container py-4">
	<h1 class="light-text mb-0">Admin - Accounts</h1>
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
				<form use:enhance method="POST" action="?/resetPassword">
					<fieldset>
						<div class="grid grid-cols-12 gap-6 light-text mb-3">
							<label
								for="username"
								class="md:col-span-3 col-form-label">
								Username
							</label>
							<div class="md:col-span-8">
								<input
									bind:value={$form.username}
									{...$constraints.username}
									name="username"
									id="username"
									class="form-control {$errors.username
										? 'is-in'
										: ''}valid" />
								<p class="col-span-12 mb-3 text-red-500">
									{$errors.username || ""}
								</p>
							</div>
						</div>
						<div class="grid grid-cols-12 gap-6 light-text mb-3">
							<label
								for="password"
								class="md:col-span-3 col-form-label">
								New password
							</label>
							<div class="md:col-span-8">
								<input
									bind:value={$form.password}
									{...$constraints.password}
									name="password"
									id="password"
									class="form-control {$errors.password
										? 'is-in'
										: ''}valid" />
								<p class="col-span-12 mb-3 text-red-500">
									{$errors.password || ""}
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
			</Tab>
		</div>
	</div>
</div>
