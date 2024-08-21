<script lang="ts">
	import User from "$components/User.svelte"

	export let report: import("./$types").PageData["reports"][0]

	const time = new Date(report.time).toLocaleString()
</script>

<tr>
	<td class="max-w-35">
		<button class="btn btn-sm btn-tertiary" popovertarget={report.id}>
			{report.id}
		</button>
	</td>
	<td class="max-w-35">{report.category}</td>
	<td><User user={report.reporter} full thin /></td>
	<td><User user={report.reportee} full thin /></td>
	<td>{time}</td>
</tr>

<div popover="auto" id={report.id} class="light-text p-4 max-w-180">
	<h1 class="text-lg">Report {report.id}</h1>
	<h2 class="text-base pt-2">Note</h2>
	<div class="pl-4 py-2">
		<blockquote>{report.note}</blockquote>
	</div>

	<hr />

	<table class="info">
		<tr>
			<td>Category</td>
			<td>{report.category}</td>
		</tr>
		<tr>
			<td>Report</td>
			<td class="flex flex-wrap gap-4 items-center">
				<User user={report.reporter} thin full />
				<i>reported</i>
				<User user={report.reportee} thin full />
			</td>
		</tr>
		<tr>
			<td>Time</td>
			<td>{time}</td>
		</tr>
		<tr>
			<td>URL</td>
			<td><a href={report.url}>{report.url}</a></td>
		</tr>
	</table>
</div>

<style>
	blockquote {
		margin: 0;
		padding: 0.5rem 0 0.5rem 1rem;
		border-left: 0.2rem solid rgba(136, 136, 136, 0.667);
		font-style: italic;
	}

	.info {
		& td {
			padding: 0.25rem 0;
		}
		& tr td:first-child {
			font-weight: bold;
			padding-right: 2rem;
		}
	}
</style>
