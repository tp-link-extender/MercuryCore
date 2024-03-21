<script lang="ts">
	import { superForm } from "sveltekit-superforms/client"

	export let data
	const formData = superForm(data.form)

	export const snapshot = formData

	let tabData = TabData(data.url, ["Change User Password"], ["far fa-key"])
</script>

<Head title="Accounts - Admin" />

<div class="ctnr max-w-240">
	<h1>Admin - Accounts</h1>
	<a href="/admin" class="no-underline">
		<fa fa-caret-left />
		Back to panel
	</a>
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
