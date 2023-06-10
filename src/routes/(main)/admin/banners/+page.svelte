<script lang="ts">
	import { page } from "$app/stores"
	import { superForm } from "sveltekit-superforms/client"
	import { writable } from "svelte/store"
	import Modal from "$lib/components/Modal.svelte"
	import { Tab, TabNav, TabData } from "$lib/components/Tabs"
	import fade from "$lib/fade"

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

	let modal = writable(false)

	let bannerId = ""
	let newBannerBody = ""
	let textarea: any

	const viewBody = (id: any, body: any) => () => {
		modal.set(true)

		bannerId = id
		$form.bannerBody = body.trim()
		newBannerBody = body.trim()
	}

	let tabData = TabData(data.url, ["Create Banner", "Banner List"])
</script>

<svelte:head>
	<title>Admin - Mercury</title>
</svelte:head>

<div class="container py-4">
	<h1 class="light-text mb-0">Admin - Banners</h1>
	<a href="/admin" class="no-underline">
		<i class="fas fa-caret-left" />
		Back to panel
	</a>
	<div class="grid grid-cols-12 gap-6 mt-4">
		<div class="lg:col-span-2 md:col-span-3 mb-4 pe-0">
			<TabNav bind:tabData tabs />
		</div>
		<div class="lg:col-span-10 md:col-span-9">
			<Tab {tabData}>
				<form use:enhance method="POST">
					<fieldset>
						<div class="grid grid-cols-12 gap-6">
							<label
								for="bannerText"
								class="md:col-span-3 col-form-label light-text">
								Banner text
							</label>
							<div class="md:col-span-8">
								<textarea
									bind:value={$form.bannerBody}
									{...$constraints.bannerBody}
									name="bannerText"
									id="bannerText"
									class="form-control {$errors.bannerBody
										? 'is-in'
										: ''}valid" />
								<small class="light-text">
									3-100 characters
								</small>
								<p class="col-span-12 mb-3 text-red-500">
									{$errors.bannerBody || ""}
								</p>
							</div>
						</div>
						<br />
						<div class="grid grid-cols-12 gap-6">
							<label
								for="bannerColour"
								class="md:col-span-3 col-form-label light-text">
								Banner colour
							</label>
							<div class="md:col-span-2">
								<input
									bind:value={$form.bannerColour}
									{...$constraints.bannerColour}
									type="color"
									name="bannerColour"
									id="bannerColour"
									class="{$errors.bannerColour
										? 'is-in'
										: ''}valid" />
								<p class="col-span-12 mb-3 text-red-500">
									{$errors.bannerColour || ""}
								</p>
							</div>
						</div>
						<br />
						<div class="grid grid-cols-12 gap-6">
							<label
								for="bannerTextLight"
								class="md:col-span-3 col-form-label light-text">
								Light text
							</label>
							<div class="md:col-span-2">
								<input
									bind:checked={$form.bannerTextLight}
									value="true"
									type="checkbox"
									name="bannerTextLight"
									id="bannerTextLight"
									class="valid form-check-input" />
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
							<th scope="col">Active</th>
							<th scope="col">Body</th>
							<th scope="col">Color</th>
							<th scope="col">Text Color</th>
							<th scope="col">Creator</th>
						</tr>
					</thead>
					<tbody class="light-text">
						{#each data.banners as banner}
							<tr>
								<td>
									<form use:enhance method="POST">
										<input
											type="hidden"
											name="id"
											value={banner.id} />
										<button
											name="action"
											value="delete"
											class="btn btn-sm btn-link no-underline text-red-500 my-0">
											<i class="fas fa-trash" />
											Delete Banner
										</button>
									</form>
									<form use:enhance method="POST">
										<input
											type="hidden"
											name="action"
											value={banner.active
												? "hide"
												: "show"} />
										<input
											type="hidden"
											name="id"
											value={banner.id} />
										<button
											type="submit"
											class="btn btn-sm btn-link no-underline text-{banner.active
												? 'warning'
												: 'success'} my-0">
											<i
												class="fas {banner.active
													? 'fa-eye-slash'
													: 'fa-eye'}" />
											{banner.active ? "Dea" : "A"}ctivate
										</button>
									</form>
								</td>
								<td>{banner.active ? "Yes" : "No"}</td>
								<td>
									<button
										type="button"
										on:click={viewBody(
											banner.id,
											banner.body
										)}
										class="btn btn-sm bg-emerald-600 hover:bg-emerald-800 text-white my-0">
										View Body
									</button>
								</td>
								<td>
									<input
										type="color"
										value={banner.bgColour}
										disabled
										class="valid" />
								</td>
								<td>
									{banner.textLight ? "Light" : "Dark"}
								</td>
								<td>
									<a
										href="/user/{banner.user.number}"
										class="no-underline">
										{banner.user.username}
									</a>
								</td>
							</tr>
						{/each}
					</tbody>
				</table>
			</Tab>
		</div>
	</div>
</div>

{#if $modal}
	<Modal {modal}>
		<div class="modal-header">
			<h1 class="h4 light-text">Banner #{bannerId}</h1>
			<button
				type="button"
				class="btn-close"
				on:click={() => modal.set(false)}
				data-bs-dismiss="modal"
				aria-label="Close" />
		</div>
		<div class="modal-body light-text">
			<form use:enhance method="POST">
				<input type="hidden" name="id" value={bannerId} />
				<textarea
					bind:value={$form.bannerBody}
					{...$constraints.bannerBody}
					name="bannerBody"
					bind:this={textarea}
					id="bannerBody"
					class="form-control {$errors.bannerBody
						? 'is-in'
						: ''}valid mb-3" />
				<p class="col-span-12 mb-3 text-red-500">
					{$errors.bannerBody || ""}
				</p>
				{#if newBannerBody.trim() != $form.bannerBody?.trim()}
					<div transition:fade class="grid">
						<button
							value="updateBody"
							class="btn bg-emerald-600 hover:bg-emerald-800 text-white"
							name="action"
							id="saveBannerBody">
							{#if $delayed}
								Working...
							{:else}
								Save changes
							{/if}
						</button>
					</div>
				{/if}
			</form>
			<p
				class:text-emerald-500={$page.status == 200}
				class:text-red-500={$page.status >= 400}>
				{$message || ""}
			</p>
		</div>
	</Modal>
{/if}

<style lang="sass">
	input[type="color"]
		height: 2.5rem

	input[type="checkbox"]
		height: 1.5rem
		width: 1.5rem

	.btn-close
		filter: invert(1) grayscale(100%) brightness(200%)
</style>
