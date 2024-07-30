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

	export let data

	const formData = superForm(data.form)
	export const snapshot = formData
	const { form } = formData

	const tomorrow = new Date(Date.now() + 86400e3).toISOString().slice(0, 10)

	let tabData = TabData(
		data.url,
		["Create Invite Key", "Invites"],
		["fa fa-envelope-circle-check", "fa fa-envelopes-bulk"]
	)
</script>

<Head name={data.siteName} title="Invites - Admin" />

<div class="ctnr max-w-240 pb-6">
	<h1>Invites &ndash; Admin</h1>
	<a href="/admin" class="no-underline">
		<fa fa-caret-left />
		Back to panel
	</a>
</div>

<SidebarShell bind:tabData>
	<Tab {tabData}>
		<Form {formData} action="?/create" submit="Create">
			<Input
				{formData}
				name="enableInviteCustom"
				label="Enable Custom Invite Key"
				type="checkbox" />
			{#if $form.enableInviteCustom}
				<div transition:fade>
					<Input
						{formData}
						name="inviteCustom"
						label="Custom Invite Key"
						help="Instead of having a randomly generated key, this allows you to set the key." />
				</div>
			{/if}
			<Input
				{formData}
				name="enableInviteExpiry"
				label="Enable Expiry"
				type="checkbox" />
			{#if $form.enableInviteExpiry}
				<div transition:fade>
					<Input
						{formData}
						name="inviteExpiry"
						label="Expiry Date"
						type="date"
						min={tomorrow}
						required />
				</div>
			{/if}
			<Input {formData} name="inviteUses" label="Uses" type="number" />
		</Form>
	</Tab>

	<Tab {tabData}>
		<table class="w-full">
			<thead>
				<tr>
					<th scope="col">Options</th>
					<th scope="col">Invite</th>
					<th scope="col">Uses Left</th>
					<th scope="col">Creator</th>
					<th scope="col">Creation Date</th>
				</tr>
			</thead>
			<tbody>
				{#each data.invites as invite}
					<tr>
						<td>
							<form
								use:enhance
								method="POST"
								action="?/disable&id={invite.id}">
								<button
									class="btn btn-sm no-underline text-red-5 my-0">
									<fa fa-ban />
									Disable Invite
								</button>
							</form>
						</td>
						<td>mercurkey-{invite.id}</td>
						<td>{invite.usesLeft}</td>
						<td>
							{#if invite.creator}
								<User user={invite.creator} full thin />
							{:else}
								<em>Nobody</em>
							{/if}
						</td>
						<td>
							{new Date(invite.created).toLocaleString()}
						</td>
					</tr>
				{/each}
			</tbody>
		</table>
	</Tab>
</SidebarShell>

<style>
	table {
		& tr,
		& td,
		& th {
			color: var(--light-text) !important;
		}
	}
</style>
