<script lang="ts">
	import { invalidate } from "$app/navigation"
	import { page } from "$app/stores"
	import { superForm } from "sveltekit-superforms/client"

	export let data

	let modal = writable(false),
		bannerData = {
			id: "",
			bgColour: "",
			textLight: false,
			body: "",
		},
		tabData = TabData(data.url, ["Create Banner", "Banner List"]),
		textLightForms: { [k: string]: HTMLFormElement } = {}

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
		}),
		viewBody = (newBannerData: typeof bannerData) => () => {
			modal.set(true)

			newBannerData.body = newBannerData.body.trim()
			$form.bannerBody = newBannerData.body
			bannerData = newBannerData
		}

	export const snapshot = { capture, restore }
</script>

<Head title="Banners - Admin" />

<div class="container py-6">
	<h1 class="light-text mb-0">Admin - Banners</h1>
	<a href="/admin" class="text-decoration-none">
		<i class="fas fa-caret-left" />
		Back to panel
	</a>
	<div class="row mt-6">
		<div class="col-lg-2 col-md-3 mb-6 pe-0">
			<TabNav bind:tabData vertical />
		</div>
		<div class="col-lg-10 col-md-9">
			<Tab {tabData}>
				<form use:enhance method="POST" action="?a=create">
					<fieldset>
						<div class="row">
							<label
								for="bannerText"
								class="col-md-3 col-form-label text-md-right light-text">
								Banner text
							</label>
							<div class="col-md-8">
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
								<p class="col-12 mb-4 text-danger">
									{$errors.bannerBody || ""}
								</p>
							</div>
						</div>
						<br />
						<div class="row">
							<label
								for="bannerColour"
								class="col-md-3 col-form-label text-md-right light-text">
								Banner colour
							</label>
							<div class="col-md-2">
								<input
									bind:value={$form.bannerColour}
									{...$constraints.bannerColour}
									type="color"
									name="bannerColour"
									id="bannerColour"
									class="{$errors.bannerColour
										? 'is-in'
										: ''}valid" />
								<p class="col-12 mb-4 text-danger">
									{$errors.bannerColour || ""}
								</p>
							</div>
						</div>
						<br />
						<div class="row">
							<label
								for="bannerTextLight"
								class="col-md-3 col-form-label text-md-right light-text">
								Light text
							</label>
							<div class="col-md-2">
								<input
									bind:checked={$form.bannerTextLight}
									value="true"
									type="checkbox"
									name="bannerTextLight"
									id="bannerTextLight"
									class="form-check-input valid" />
							</div>
						</div>
						<button class="btn btn-success mt-4">
							{#if $delayed}
								Working...
							{:else}
								Create
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

			<Tab {tabData}>
				<table class="w-100 light-text">
					<thead>
						<tr>
							<th scope="col">Options</th>
							<th scope="col">Active</th>
							<th scope="col">Body</th>
							<th scope="col">Color</th>
							<th scope="col">Text Color</th>
							<th scope="col">Creator</th>
						</tr>
					</thead>
					<tbody>
						{#each data.banners as banner}
							<tr>
								<td>
									<form
										use:enhance
										method="POST"
										action="?id={banner.id}&a=delete">
										<button
											class="btn btn-sm btn-link text-decoration-none text-danger">
											<i class="fas fa-trash pe-1" />
											Delete Banner
										</button>
									</form>
									<form
										use:enhance
										method="POST"
										action="?id={banner.id}&a={banner.active
											? 'hide'
											: 'show'}">
										<button
											class="btn btn-sm btn-link text-decoration-none text-{banner.active
												? 'warning'
												: 'success'}">
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
										on:click={viewBody(banner)}
										class="btn btn-sm btn-success">
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
								<td class="d-flex align-items-center">
									<form
										use:enhance
										bind:this={textLightForms[banner.id]}
										method="POST"
										class="px-2"
										action="?id={banner.id}&a=updateTextLight">
										<input
											on:change={async () => {
												textLightForms[
													banner.id
												].requestSubmit()
												await invalidate(
													window.location.href
												)
											}}
											checked={banner.textLight}
											type="checkbox"
											name="bannerTextLight"
											value="true"
											id="bannerTextLight"
											class="form-check-input valid" />
									</form>
									{banner.textLight ? "Light" : "Dark"}
								</td>
								<td>
									<User
										user={banner.creator}
										full
										thin
										bg="accent" />
								</td>
							</tr>
						{/each}
					</tbody>
				</table>
				<p
					class:text-success={$page.status == 200}
					class:text-danger={$page.status >= 400}>
					{$message || ""}
				</p>
			</Tab>
		</div>
	</div>
</div>

{#if $modal}
	<Modal {modal}>
		<div class="d-flex">
			<h1 class="fs-4 pe-4 light-text">Banner #{bannerData.id}</h1>
			<button
				type="button"
				class="btn-close"
				on:click={() => modal.set(false)}
				aria-label="Close" />
		</div>
		<form
			use:enhance
			method="POST"
			action="?id={bannerData.id}&a=updateBody">
			<textarea
				bind:value={$form.bannerBody}
				{...$constraints.bannerBody}
				name="bannerBody"
				id="bannerBody"
				rows="1"
				class="form-control {$errors.bannerBody
					? 'is-in'
					: ''}valid mb-4 text-{bannerData.textLight
					? 'light'
					: 'dark'}"
				style="background: {bannerData.bgColour} !important" />
			<p class="col-12 mb-4 text-danger">
				{$errors.bannerBody || ""}
			</p>
			{#if $form.bannerBody?.trim() && bannerData.body.trim() != $form.bannerBody?.trim()}
				<div transition:fade class="d-grid gap-2">
					<button
						on:click={() => modal.set(false)}
						class="btn btn-success"
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
	</Modal>
{/if}

<style lang="stylus">
	input[type="color"]
		height 2.5rem

	input[type="checkbox"]
		height 1.5rem
		width 1.5rem

	.btn-close
		filter invert(1) grayscale(100%) brightness(200%)
	+lightTheme()
		.btn-close
			filter none

	td
		height: 4.8rem
</style>
