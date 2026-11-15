<script lang="ts">
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"
	import Textarea from "$components/forms/Textarea.svelte"
	import Head from "$components/Head.svelte"
	import SidebarShell from "$components/SidebarShell.svelte"
	import Tab from "$components/Tab.svelte"
	import TabData from "$components/TabData"
	import User from "$components/User.svelte"
	import {
		bodyForm,
		deleteForm,
		formData,
		textLightForm,
		visibilityForm,
	} from "./banners.remote.js"

	const { data } = $props()

	let tabData = $state(
		TabData(
			data.url,
			["Create Banner", "Banner List"],
			["fa-plus", "fa-list"]
		)
	)
</script>

<Head name={data.siteName} title="Banners - Admin" />

<div class="ctnr max-w-280 pb-6">
	<h1>Banners &ndash; Admin</h1>
	<a href="/admin" class="no-underline">
		<fa fa-caret-left></fa>
		Back to panel
	</a>
</div>

<SidebarShell bind:tabData class="max-w-280">
	<Tab bind:tabData>
		<Form {formData} submit="<fa fa-plus></fa> Create">
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

	<Tab bind:tabData>
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
					{const remove = deleteForm.for(banner.id)}
					{const visibility = visibilityForm.for(banner.id)}
					{const textLight = textLightForm.for(banner.id)}
					<tr>
						<td>
							<form {...remove}>
								<button
									class="btn py-0 no-underline text-red-500">
									<fa fa-trash class="pr-1"></fa>
									Delete Banner
								</button>
							</form>
							<form {...visibility}>
								<input
									{...visibility.fields.action.as(
										"hidden",
										banner.active ? "hide" : "show"
									)} />
								<button
									class="btn py-0 no-underline {banner.active
										? 'text-yellow-500'
										: 'text-emerald-500'}">
									<fa
										class={banner.active
											? "fa-eye-slash"
											: "fa-eye"}>
									</fa>
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
							<form {...textLight} class="px-2">
								<input
									{...textLight.fields.bannerTextLight.as(
										"checkbox"
									)}
									checked={banner.textLight}
									onchange={e =>
										e.currentTarget.form?.requestSubmit()}
									id="bannerTextLight"
									class="valid" />
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
		<p class="text-emerald-600">
			{formData.result?.success || ""}
		</p>
	</Tab>
</SidebarShell>

{#each data.banners as banner}
	{const body = bodyForm.for(banner.id)}
	<div id={banner.id} popover="auto" class="light-text p-4 pb-2 w-100">
		<h1 class="text-lg pb-2">Banner #{banner.id}</h1>

		<form {...body}>
			<Textarea
				formData={body}
				name="bannerBody"
				rows={1}
				placeholder="3-100 characters"
				lowpad
				defaultValue={banner.body}
				class="text-{banner.textLight ? 'light' : 'dark'}"
				style="background: {banner.bgColour} !important" />
			<button class="btn btn-primary">
				<fa fa-save></fa>
				Save changes
			</button>
		</form>
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
