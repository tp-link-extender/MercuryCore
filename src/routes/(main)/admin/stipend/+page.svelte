<script lang="ts">
	import { page } from "$app/stores"
	import superForm from "$lib/superForm"

	export let data
	const formData = superForm(data.form)
	const { form, errors, message, constraints, enhance, delayed } = formData

	export const snapshot = formData

	$form.dailyStipend = data.dailyStipend
	$form.stipendTime = data.stipendTime

	let tabData = TabData(data.url, ["Daily Stipend"])
</script>

<Head title="Daily Stipend - Admin" />

<div class="ctnr pt-6 light-text">
	<h1>Admin - Daily Stipend</h1>
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
			<Tab {tabData}>
				<Form {formData} action="?/updateStipend" submit="Save changes">
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
		</div>
	</div>
</div>
