<script lang="ts">
	import { enhance } from "$app/forms"
	import { invalidate } from "$app/navigation"
	import { page } from "$app/stores"
	import Head from "$components/Head.svelte"
	import SidebarShell from "$components/SidebarShell.svelte"
	import Tab from "$components/Tab.svelte"
	import TabData from "$components/TabData"
	import User from "$components/User.svelte"
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"
	import Textarea from "$components/forms/Textarea.svelte"
	import { superForm } from "sveltekit-superforms/client"

	export let data

	let tabData = TabData(
		data.url,
		["Create Banner", "Banner List"],
		["fa-plus", "fa-list"]
	)
	let textLightForms: { [k: string]: HTMLFormElement } = {}

	const formData = superForm(data.form)
	export const snapshot = formData
	const { message } = formData
</script>

<Head name={data.siteName} title="Banners - Admin" />

<div class="ctnr max-w-280 pb-6">
	<h1>Banners &ndash; Admin</h1>
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
									class="btn py-0 no-underline text-red-500">
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
										? 'text-yellow-500'
										: 'text-emerald-500'}">
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
								popovertarget={banner.id}
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
								action="?/updateTextLight&id={banner.id}"
								class="px-2">
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
			class:text-emerald-600={$page.status === 200}
			class:text-red-500={$page.status >= 400}>
			{$message || ""}
		</p>
	</Tab>
</SidebarShell>

{#each data.banners as banner}
	<div id={banner.id} popover="auto" class="light-text p-4 pb-2 w-100">
		<h1 class="text-lg pb-2">Banner #{banner.id}</h1>

		<Form
			{formData}
			submit="<fa fa-save class='pr-2'></fa> Save changes"
			action="?/updateBody&id={banner.id}">
			<Textarea
				{formData}
				name="bannerBody"
				rows={1}
				placeholder="3-100 characters"
				lowpad
				class="text-{banner.textLight ? 'light' : 'dark'}"
				style="background: {banner.bgColour} !important" />
		</Form>
	</div>
{/each}

<style>
	input[type="color"] {
		height: 2.5rem;
		border-radius: var(--rounding);
	}

	td {
		height: 4.8rem;
	}
</style>
