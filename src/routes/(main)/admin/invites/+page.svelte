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

	let tabData = TabData(data.url, ["Create Invite Key", "Invites"])
</script>

<svelte:head>
	<title>Admin - Mercury</title>
</svelte:head>

<div class="container py-4">
	<h1 class="light-text mb-0">Admin - Invites</h1>
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
				<form use:enhance method="POST">
					<fieldset>
						<div class="grid grid-cols-12 gap-6">
							<label
								for="enableInviteCustom"
								class="md:col-span-3 col-form-label light-text">
								Enable custom invite key
							</label>
							<div class="md:col-span-2">
								<input
									bind:checked={$form.enableInviteCustom}
									{...$constraints.enableInviteCustom}
									type="checkbox"
									name="enableInviteCustom"
									id="enableInviteCustom"
									value="true"
									class="form-check-input valid" />
							</div>
						</div>
						<br />
						{#if $form.enableInviteCustom}
							<div
								class="grid grid-cols-12 gap-6"
								transition:fade>
								<label
									for="inviteCustom"
									class="md:col-span-3 col-form-label light-text">
									Custom invite key
								</label>
								<div class="md:col-span-8">
									<input
										bind:value={$form.inviteCustom}
										{...$constraints.inviteCustom}
										type="text"
										name="inviteCustom"
										id="inviteCustom"
										class="form-control {$errors.inviteCustom
											? 'is-in'
											: ''}valid" />
									<small class="light-text">
										Instead of having a randomly generated
										key, this allows you to set the key.
									</small>
									<p class="col-span-12 mb-3 text-red-500">
										{$errors.inviteCustom || ""}
									</p>
								</div>
							</div>
							<br />
						{/if}
						<div class="grid grid-cols-12 gap-6">
							<label
								for="enableInviteExpiry"
								class="md:col-span-3 col-form-label light-text">
								Enable expiry
							</label>
							<div class="md:col-span-2">
								<input
									bind:checked={$form.enableInviteExpiry}
									{...$constraints.enableInviteExpiry}
									type="checkbox"
									name="enableInviteExpiry"
									id="enableInviteExpiry"
									value="true"
									class="form-check-input valid" />
							</div>
						</div>
						<br />
						{#if $form.enableInviteExpiry}
							<div
								class="grid grid-cols-12 gap-6"
								transition:fade>
								<label
									for="inviteExpiry"
									class="md:col-span-3 col-form-label light-text">
									Expiry date
								</label>
								<div class="md:col-span-8">
									<input
										bind:value={$form.inviteExpiry}
										{...$constraints.inviteExpiry}
										type="date"
										name="inviteExpiry"
										id="inviteExpiry"
										min={tomorrow}
										required
										class="form-control {$errors.inviteExpiry
											? 'is-in'
											: ''}valid" />
									<p class="col-span-12 mb-3 text-red-500">
										{$errors.inviteExpiry || ""}
									</p>
								</div>
							</div>
							<br />
						{/if}
						<div class="grid grid-cols-12 gap-6">
							<label
								for="inviteUses"
								class="md:col-span-3 col-form-label light-text">
								Uses
							</label>
							<div class="md:col-span-8">
								<input
									bind:value={$form.inviteUses}
									{...$constraints.inviteUses}
									type="number"
									name="inviteUses"
									id="inviteUses"
									class="form-control {$errors.inviteUses
										? 'is-in'
										: ''}valid" />
								<p class="col-span-12 mb-3 text-red-500">
									{$errors.inviteUses || ""}
								</p>
							</div>
						</div>
						<button
							name="action"
							value="create"
							class="btn bg-emerald-600 hover:bg-emerald-800 text-white mt-3">
							{#if $delayed}
								Working...
							{:else}
								Create
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

			<Tab {tabData}>
				<table class="table table-responsive">
					<thead class="light-text">
						<tr>
							<th scope="col">Options</th>
							<th scope="col">Invite</th>
							<th scope="col">Uses Left</th>
							<th scope="col">Creator</th>
							<th scope="col">Creation Date</th>
						</tr>
					</thead>
					<tbody class="light-text">
						{#each data.invites as invite}
							<tr>
								<td>
									<form use:enhance method="POST">
										<input
											type="hidden"
											name="id"
											value={invite.key} />
										<button
											name="action"
											value="disable"
											class="btn btn-sm btn-link no-underline text-red-500 my-0">
											<i class="fas fa-ban" />
											Disable Invite
										</button>
									</form>
								</td>
								<td>mercurkey-{invite.key}</td>
								<td>{invite.usesLeft}</td>
								<td>{invite.creator?.username}</td>
								<td>
									{new Date(
										invite.creation
									).toLocaleDateString()}
								</td>
							</tr>
						{/each}
					</tbody>
				</table>
			</Tab>
		</div>
	</div>
</div>

<style lang="sass">
	input[type="checkbox"]
		height: 1.5rem
		width: 1.5rem

	input[type="number"]
		width: 10rem
</style>
