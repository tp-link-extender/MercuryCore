<script lang="ts">
	import superForm from "$lib/superForm"

	export let data
	const formData = superForm(data.form)

	export const snapshot = formData
</script>

<Head title="Report {data.reportee}" />

<h1 class="text-center">Report</h1>

<div class="ctnr pt-12 max-w-180 light-text">
	<h2 class="text-xl pb-6">
		Tell us how you think {data.reportee} is breaking the rules.
	</h2>

	<Form {formData}>
		<Select {formData} name="category" label="Report category">
			<option value="AccountTheft">Account theft</option>
			<option value="Dating">Dating</option>
			<option value="Exploiting">Exploiting</option>
			<option value="Harassment">Harassment or discrimination</option>
			<option value="InappropriateContent">Inappropriate content</option>
			<option value="PersonalInformation">
				Personal information (displaying their own or asking for
				others')
			</option>
			<option value="Scamming">Scamming</option>
			<option value="Under13">Suspected under 13 user</option>
			<option value="Spam">Spam</option>
			<option value="Swearing">Swearing</option>
			<option value="Threats">Threats</option>
		</Select>
		<Textarea
			{formData}
			name="note"
			label="Further information"
			placeholder="Up to 1000 characters"
			rows="5" />
	</Form>
</div>
