<script lang="ts">
	import superForm from "$lib/superForm"

	export let data
	const formData = superForm(data.form)

	export const snapshot = formData

	let tabData = TabData(data.url, ["Reset User Password"])
</script>

<Head title="Accounts - Admin" />

<div class="ctnr pt-6 max-w-280 light-text">
	<h1>Admin - Accounts</h1>
	<a href="/admin" class="no-underline">
		<fa fa-caret-left />
		Back to panel
	</a>
	<div class="flex flex-wrap pt-6">
		<TabNav
			bind:tabData
			vertical
			class="w-full lg:w-1/6 md:w-1/4 pb-6 md:pr-4" />
		<div class="w-full lg:w-5/6 md:w-3/4">
			<Form {formData} submit="Reset">
				<Input {formData} name="username" label="Username" />
				<Input
					{formData}
					name="password"
					label="New password"
					type="password"
					placeholder={"•".repeat(20)} />
			</Form>
		</div>
	</div>
</div>
