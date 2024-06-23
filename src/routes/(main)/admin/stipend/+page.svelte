<script lang="ts">
	import Form from "$lib/components/forms/Form.svelte"
	import Input from "$lib/components/forms/Input.svelte"
	import { superForm } from "sveltekit-superforms/client"

	export let data
	const formData = superForm(data.form)
	const { form } = formData

	export const snapshot = formData

	$form.dailyStipend = data.dailyStipend
	$form.stipendTime = data.stipendTime

	let tabData = TabData(data.url, ["Daily stipend"], ["fa fa-gem"])
</script>

<Head title="Daily stipend - Admin" />

<div class="ctnr max-w-240 pb-6">
	<h1>Admin - Daily stipend</h1>
	<a href="/admin" class="no-underline">
		<fa fa-caret-left />
		Back to panel
	</a>
</div>

<SidebarShell bind:tabData>
	<Tab {tabData}>
		<Form
			{formData}
			action="?/updateStipend"
			submit={$form.dailyStipend > 2 * data.dailyStipend // funny
				? "<far fa-money-bill-trend-up></far> Make it rain!"
				: "<fa fa-save></fa> Save changes"}>
			<Input
				{formData}
				name="dailyStipend"
				label="Daily stipend"
				type="number"
				after="<fa fa-gem class='text-emerald-6 pl-3' />" />
			<Input
				{formData}
				name="stipendTime"
				label="Time between stipend"
				type="number"
				after="<span class='light-text pl-3'>hours</span>" />
		</Form>
	</Tab>
</SidebarShell>
