<script lang="ts">
	import { enhance } from "$app/forms"
	import Head from "$components/Head.svelte"
	import SidebarShell from "$components/SidebarShell.svelte"
	import Tab from "$components/Tab.svelte"
	import TabData from "$components/TabData"
	import User from "$components/User.svelte"
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"
	import fade from "$lib/fade"
	import { superForm } from "sveltekit-superforms/client"

	let { data } = $props();

	const formData = superForm(data.form)
	export const snapshot = formData
	const { form } = formData

	const tomorrow = new Date(Date.now() + 86400e3).toISOString().slice(0, 10)

	let tabData = $state(TabData(
		data.url,
		["Create Key", "Keys"],
		["fa-key", "fa-envelopes-bulk"]
	))
</script>

<Head name={data.siteName} title="Registration Keys - Admin" />

<div class="ctnr max-w-280 pb-6">
	<h1>Registration Keys &ndash; Admin</h1>
	<a href="/admin" class="no-underline">
		<fa fa-caret-left></fa>
		Back to panel
	</a>
</div>

<SidebarShell bind:tabData class="max-w-280">
	<Tab {tabData}>
		<Form {formData} action="?/create" submit="Create">
			<Input
				{formData}
				name="enableRegKeyCustom"
				label="Enable custom key"
				type="checkbox" />
			{#if $form.enableRegKeyCustom}
				<div transition:fade>
					<Input
						{formData}
						name="regKeyCustom"
						label="Custom registration key"
						help="Instead of having a randomly generated key, this allows you to set the key." />
				</div>
			{/if}
			<Input
				{formData}
				name="enableRegKeyExpiry"
				label="Enable expiry"
				type="checkbox" />
			{#if $form.enableRegKeyExpiry}
				<div transition:fade>
					<Input
						{formData}
						name="regKeyExpiry"
						label="Expiry date"
						type="date"
						min={tomorrow}
						required />
				</div>
			{/if}
			<Input {formData} name="regKeyUses" label="Uses" type="number" />
		</Form>
	</Tab>

	<Tab {tabData}>
		<table class="w-full">
			<thead>
				<tr>
					<th scope="col">Options</th>
					<th scope="col">Registration key</th>
					<th scope="col">Uses left</th>
					<th scope="col">Creator</th>
					<th scope="col">Created</th>
				</tr>
			</thead>
			<tbody>
				{#each data.regKeys as regKey}
					<tr>
						<td>
							<form
								use:enhance
								method="POST"
								action="?/disable&id={regKey.id}">
								<button
									class="btn btn-sm no-underline text-red-500 my-0">
									<fa fa-ban></fa>
									Disable key
								</button>
							</form>
						</td>
						<td>{data.prefix}{regKey.id}</td>
						<td>{regKey.usesLeft}</td>
						<td>
							{#if regKey.creator}
								<User user={regKey.creator} full thin />
							{:else}
								<em>Nobody</em>
							{/if}
						</td>
						<td>
							{new Date(regKey.created).toLocaleString()}
						</td>
					</tr>
				{/each}
			</tbody>
		</table>
	</Tab>
</SidebarShell>
