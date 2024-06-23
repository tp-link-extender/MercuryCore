<script lang="ts">
	import Head from "$lib/components/Head.svelte"
	import SidebarShell from "$lib/components/SidebarShell.svelte"
	import Tab from "$lib/components/Tab.svelte"
	import TabData from "$lib/components/TabData"
	import Form from "$lib/components/forms/Form.svelte"
	import Input from "$lib/components/forms/Input.svelte"
	import Select from "$lib/components/forms/Select.svelte"
	import Textarea from "$lib/components/forms/Textarea.svelte"
	import fade from "$lib/fade"
	import { superForm } from "sveltekit-superforms/client"

	export let data
	const formData = superForm(data.form)
	const { form } = formData
	const tomorrow = new Date(Date.now() + 86400e3).toISOString().slice(0, 10)

	const moderationOptions = [
		["1", "Warning"],
		["2", "Ban"],
		["3", "Termination"],
		["4", "Account Deletion"],
		["5", "Unban"]
	]

	export const snapshot = formData

	let tabData = TabData(data.url, ["Moderate User"], ["far fa-gavel"])
</script>

<Head title="Moderate User - Admin" />

<div class="ctnr max-w-280 pb-6">
	<h1>Admin - Moderate User</h1>
	<a href="/admin" class="no-underline">
		<fa fa-caret-left />
		Back to panel
	</a>
</div>

<SidebarShell bind:tabData class="max-w-280">
	<Tab {tabData}>
		<Form
			{formData}
			submit={$form.action === "3" || $form.action === "4" // 5:53 am and im bored as shit
				? "<fa fa-explosion></fa> TERMINATE THAT MOTHAFUCKA!!!!"
				: $form.action === "5"
					? "<fa fa-unlock></fa> Unban"
					: "<fa fa-hammer-crash></fa> Moderate"}>
			<Input {formData} name="username" label="Username" />
			<Select
				{formData}
				options={moderationOptions}
				name="action"
				label="Action" />
			{#if $form.action === "2"}
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
</SidebarShell>
