<script lang="ts">
	// TODO: doesn't work without clientside JS because of the date input, fix

	import { superForm } from "sveltekit-superforms/client"
	import Form from "$components/forms/Form.svelte"
	import Input from "$components/forms/Input.svelte"
	import Select from "$components/forms/Select.svelte"
	import Textarea from "$components/forms/Textarea.svelte"
	import Head from "$components/Head.svelte"
	import SidebarShell from "$components/SidebarShell.svelte"
	import Tab from "$components/Tab.svelte"
	import TabData from "$components/TabData"
	import fade from "$lib/fade"
	import moderationOptions from "./moderationOptions"

	const { data } = $props()

	let formData = $derived(superForm(data.form))
	export const snapshot = formData
	let { form } = $derived(formData)

	$effect(() => {
		if (data.report) $form.reason = data.report.note
	})

	const tomorrow = new Date(Date.now() + 86400e3).toISOString().slice(0, 10)

	let tabData = $state(TabData(data.url, ["User moderation"], ["fa-gavel"]))
</script>

<Head name={data.siteName} title="User moderation - Admin" />

<div class="ctnr max-w-280 pb-6">
	<h1>User moderation &ndash; Admin</h1>
	<a href="/admin" class="no-underline">
		<fa fa-caret-left></fa>
		Back to panel
	</a>
</div>

<SidebarShell bind:tabData class="max-w-280">
	<Tab bind:tabData>
		<Form
			{formData}
			submit={$form.action === "Termination" // 5:53 am and im bored as shit
				? "<fa fa-explosion></fa> Nuke from orbit"
				: $form.action === "Unban"
					? "<fa fa-unlock></fa> Unban"
					: "<fa fa-hammer-crash></fa> Moderate"}>
			<Input {formData} name="username" label="Username" />
			<Select
				{formData}
				options={moderationOptions}
				name="action"
				label="Action" />
			{#if $form.action === "Ban"}
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
