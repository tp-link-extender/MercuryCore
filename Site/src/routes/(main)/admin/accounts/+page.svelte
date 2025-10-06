<script lang="ts">
	import { superForm } from "sveltekit-superforms/client"
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"
	import Head from "$components/Head.svelte"
	import SidebarShell from "$components/SidebarShell.svelte"
	import Tab from "$components/Tab.svelte"
	import TabData from "$components/TabData"
	import User from "$components/User.svelte"

	const { data } = $props()

	const formData = superForm(data.form)
	export const snapshot = formData

	let tabData = $state(
		TabData(data.url, ["Change user password", "Users"], ["fa-key", "fa-user"])
	)
</script>

<Head name={data.siteName} title="Accounts - Admin" />

<div class="ctnr max-w-240 pb-6">
	<h1>Accounts &ndash; Admin</h1>
	<a href="/admin" class="no-underline">
		<fa fa-caret-left></fa>
		Back to panel
	</a>
</div>

<SidebarShell bind:tabData>
	<Tab bind:tabData>
		<Form
			{formData}
			submit="<fa fa-key></fa> Change password"
			action="?/changePassword">
			<Input {formData} name="username" label="Username" />
			<Input
				{formData}
				name="password"
				label="New password"
				type="password"
				placeholder={"•".repeat(20)} />
		</Form>
	</Tab>
	<Tab bind:tabData>
		<table class="w-full">
			<tbody>
				{#each data.users as user}
					<tr>
						<td><User {user} full thin bg="accent"/></td>
					</tr>
				{/each}
			</tbody>
		</table>
	</Tab>
</SidebarShell>

<style>
	tbody tr:nth-child(2n-1) {
		background: var(--darker);
	}
</style>

