<script lang="ts">
	import superForm from "$lib/superForm"
	import AdminShell from "../AdminShell.svelte"

	export let data
	const formData = superForm(data.form)
	const { form } = formData

	export const snapshot = formData

	const tomorrow = new Date(Date.now() + 86400e3).toISOString().slice(0, 10)

	let tabData = TabData(data.url, ["Moderate User"], ["far fa-gavel"])
</script>

<Head title="Moderate User - Admin" />

<div class="ctnr pt-6 max-w-280 light-text">
	<div class="pb-4">
		<h1>Admin - Moderate User</h1>
		<a href="/admin" class="no-underline">
			<fa fa-caret-left />
			Back to panel
		</a>
	</div>

	<AdminShell bind:tabData>
		<Tab {tabData}>
			<Form
				{formData}
				submit={$form.action === "3" || $form.action === "4" // 5:53 am and im bored as shit
					? "<fa fa-explosion></fa> TERMINATE THAT MOTHAFUCKA!!!!"
					: $form.action === "5"
						? "<fa fa-unlock></fa> Unban"
						: "<fa fa-hammer-crash></fa> Moderate"}>
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
	</AdminShell>
</div>
