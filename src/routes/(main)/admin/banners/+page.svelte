<script lang="ts">
	import { invalidate } from "$app/navigation"
	import { page } from "$app/stores"
	import { superForm } from "sveltekit-superforms/client"

	export let data

	let modal = writable(false)
	let tabData = TabData(
		data.url,
		["Create Banner", "Banner List"],
		["fa fa-plus", "fa fa-list"]
	)
	let textLightForms: { [k: string]: HTMLFormElement } = {}
	let bannerData = {
		id: "",
		bgColour: "",
		textLight: false,
		body: ""
	}

	const formData = superForm(data.form)
	const { form, message, delayed } = formData
	const viewBody = (newBannerData: typeof bannerData) => () => {
		modal.set(true)

		newBannerData.body = newBannerData.body.trim()
		$form.bannerBody = newBannerData.body
		bannerData = newBannerData
	}

	export const snapshot = formData
</script>

<Head title="Banners - Admin" />

<div class="ctnr max-w-280 pb-6">
	<h1>Admin - Banners</h1>
	<a href="/admin" class="no-underline">
		<fa fa-caret-left />
		Back to panel
	</a>
</div>

<SidebarShell bind:tabData class="max-w-280">
	<Tab {tabData}>
		<Form {formData} submit="<fa fa-plus></fa> Create" action="?/create">
			<Textarea
				{formData}
				name="bannerText"
				label="Banner text"
				placeholder="3-100 characters" />
			<Input
				{formData}
				name="bannerColour"
				label="Banner colour"
				type="color" />
			<Input
				{formData}
				name="bannerTextLight"
				label="Light text"
				type="checkbox" />
		</Form>
	</Tab>

	<Tab {tabData}>
		<table class="w-full light-text">
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
								action="?/delete&id={banner.id}">
								<button
									class="btn py-0 no-underline text-red-5">
									<fa fa-trash class="pr-1" />
									Delete Banner
								</button>
							</form>
							<form
								use:enhance
								method="POST"
								action="?/{banner.active
									? 'hide'
									: 'show'}&id={banner.id}">
								<button
									class="btn py-0 no-underline {banner.active
										? 'text-yellow-5'
										: 'text-emerald-5'}">
									<fa
										class={banner.active
											? "fa-eye-slash"
											: "fa-eye"} />
									{banner.active ? "Deactivate" : "Activate"}
								</button>
							</form>
						</td>
						<td>{banner.active ? "Yes" : "No"}</td>
						<td>
							<button
								type="button"
								on:click={viewBody(banner)}
								class="btn btn-sm btn-tertiary">
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
						<td class="flex items-center">
							<form
								use:enhance
								bind:this={textLightForms[banner.id]}
								method="POST"
								class="px-2"
								action="?/updateTextLight&id={banner.id}">
								<input
									on:change={async () => {
										textLightForms[
											banner.id
										].requestSubmit()
										await invalidate(window.location.href)
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
							<User user={banner.creator} full thin bg="accent" />
						</td>
					</tr>
				{/each}
			</tbody>
		</table>
		<p
			class:text-emerald-6={$page.status === 200}
			class:text-red-5={$page.status >= 400}>
			{$message || ""}
		</p>
	</Tab>
</SidebarShell>

{#if $modal}
	<Modal {modal}>
		<div class="flex items-start">
			<h1 class="text-base pr-4">Banner #{bannerData.id}</h1>
			<button
				type="button"
				class="btn p-0 px-2"
				on:click={() => modal.set(false)}
				aria-label="Close">
				<fa fa-xmark-large />
			</button>
		</div>

		<Form {formData} submit="" action="?/updateBody&id={bannerData.id}">
			<Textarea
				{formData}
				name="bannerBody"
				rows="1"
				placeholder="3-100 characters"
				class="text-{bannerData.textLight ? 'light' : 'dark'}"
				style="background: {bannerData.bgColour} !important" />
			<div transition:fade class="grid my-0">
				<button
					on:click={() => modal.set(false)}
					class="btn btn-primary"
					disabled={!$form.bannerBody?.trim() ||
						bannerData.body.trim() === $form.bannerBody?.trim()}
					id="saveBannerBody">
					{#if $delayed}
						Working...
					{:else}
						<fa fa-save class="pr-1" />
						Save changes
					{/if}
				</button>
			</div>
		</Form>
	</Modal>
{/if}

<style lang="stylus">
	input[type=color]
		height 2.5rem
		border-radius var(--rounding)

	td
		height: 4.8rem
</style>
