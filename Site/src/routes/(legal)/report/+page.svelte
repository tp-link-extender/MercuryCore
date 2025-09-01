<script lang="ts">
	import { superForm } from "sveltekit-superforms/client"
	import Form from "$components/forms/Form.svelte"
	import Select from "$components/forms/Select.svelte"
	import Textarea from "$components/forms/Textarea.svelte"
	import Head from "$components/Head.svelte"

	const { data } = $props()

	const formData = superForm(data.form)
	export const snapshot = formData

	const reports: [string, string][] = [
		["AccountTheft", "Account theft"],
		["Dating", "Dating"],
		["Exploiting", "Exploiting"],
		["Harassment", "Harassment or discrimination"],
		["InappropriateContent", "Inappropriate content"],
		[
			"PersonalInformation",
			"Personal information (displaying their own or asking for others')"
		],
		["Scamming", "Scamming"],
		["Under13", "Suspected under 13 user"],
		["Spam", "Spam"],
		["Swearing", "Swearing"],
		["Threats", "Threats"]
	]
</script>

<Head name={data.siteName} title="Report {data.reportee}" />

<h1 class="text-center">Report</h1>

<div class="ctnr pt-12 max-w-180 light-text">
	<h2 class="text-xl pb-6">
		Tell us how you think {data.reportee} is breaking the rules.
	</h2>

	<Form {formData}>
		<Select
			{formData}
			options={reports}
			name="category"
			label="Report category" />
		<Textarea
			{formData}
			name="note"
			label="Further information"
			placeholder="Up to 1000 characters"
			rows={5} />
	</Form>
</div>
