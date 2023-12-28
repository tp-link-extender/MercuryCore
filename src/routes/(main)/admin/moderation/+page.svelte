<script lang="ts">
	import superForm from "$lib/superForm"

	export let data
	const formData = superForm(data.form)
	const { form } = formData

	export const snapshot = formData

	const tomorrow = new Date(Date.now() + 86400e3).toISOString().slice(0, 10)

	let tabData = TabData(data.url, ["Moderate User"])
</script>

<Head title="Moderate User - Admin" />

<div class="ctnr pt-6 max-w-280 light-text">
	<h1 class="mb-0">Admin - Moderate User</h1>
	<a href="/admin" class="no-underline">
		<fa fa-caret-left />
		Back to panel
	</a>

	<div class="flex flex-wrap pt-6">
		<div class="w-full lg:w-1/6 md:w-1/4 pb-6">
			<TabNav bind:tabData vertical />
		</div>
		<div class="w-full lg:w-5/6 md:w-3/4">
			<Tab {tabData}>
				<Form {formData} submit="Moderate">
					<Input {formData} name="username" label="Username" />
					<Select {formData} name="action" label="Action">
						<option value="1">Warning</option>
						<option value="2">Ban</option>
						<option value="3">Termination</option>
						<option value="4">Account Deletion</option>
						<option value="5">Unban</option>
					</Select>
					{#if $form.action == "2"}
						<div transition:fade>
							<Input
								{formData}
								name="banDate"
								label="Ban until"
								type="date"
								min={tomorrow}
								required />
						</div>
					{/if}
					<Textarea {formData} name="reason" label="Reason" />
				</Form>
			</Tab>
		</div>
	</div>
</div>
