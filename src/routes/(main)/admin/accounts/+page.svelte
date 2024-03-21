<script lang="ts">
	import { superForm } from "sveltekit-superforms/client"

	export let data
	const formData = superForm(data.form)

	export const snapshot = formData

	let tabData = TabData(data.url, ["Change User Password"], ["far fa-key"])
</script>

<Head title="Accounts - Admin" />

<div class="flex px-4">
	<div class="<lg:hidden w-75" />
	<div class="flex w-full justify-center">
		<div class="w-full max-w-240 <md:px-4">
			<h1>Admin - Accounts</h1>
			<a href="/admin" class="no-underline">
				<fa fa-caret-left />
				Back to panel
			</a>
		</div>
		<div class="<lg:hidden shrink-9999 w-75" />
	</div>
</div>

<div class="px-4 pt-6">
	<SidebarShell bind:tabData>
		<Form
			{formData}
			submit="<far fa-key></far> Change password"
			action="?/changePassword">
			<Input {formData} name="username" label="Username" />
			<Input
				{formData}
				name="password"
				label="New password"
				type="password"
				placeholder={"•".repeat(20)} />
		</Form>
	</SidebarShell>
</div>
