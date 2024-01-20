<script lang="ts">
	import superForm from "$lib/superForm"
	import AdminShell from "../AdminShell.svelte"

	export let data
	const formData = superForm(data.form)

	export const snapshot = formData

	let tabData = TabData(data.url, ["Reset User Password"])
</script>

<Head title="Accounts - Admin" />

<div class="ctnr pt-6 max-w-280 light-text">
	<div class="pb-4">
		<h1>Admin - Accounts</h1>
		<a href="/admin" class="no-underline">
			<fa fa-caret-left />
			Back to panel
		</a>
	</div>

	<AdminShell bind:tabData>
		<Form {formData} submit="Reset" action="?/resetPassword">
			<Input {formData} name="username" label="Username" />
			<Input
				{formData}
				name="password"
				label="New password"
				type="password"
				placeholder={"•".repeat(20)} />
		</Form>
	</AdminShell>
</div>
