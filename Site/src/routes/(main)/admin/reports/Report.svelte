<script lang="ts">
	import User from "$components/User.svelte"

	export let report: import("./$types").PageData["reports"][0]
</script>

<div id={report.id} class="light-text p-4 max-w-180" popover="auto">
	<h1 class="text-lg">Report #{report.id}</h1>
	<h2 class="text-base pt-2">Note</h2>
	<span class="pl-4 py-2">
		<blockquote>{report.note}</blockquote>
	</span>

	<table>
		<tbody>
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
				<td>{new Date(report.time).toLocaleString()}</td>
			</tr>
			<tr>
				<td>URL</td>
				<td><a href={report.url}>{report.url}</a></td>
			</tr>
		</tbody>
	</table>

	<a href="/admin/moderation?report={report.id}" class="btn btn-secondary">
		Moderate reportee
	</a>
</div>

<style>
	blockquote {
		margin: 0;
		padding: 0.5rem 0 0.5rem 1rem;
		border-left: 0.2rem solid rgba(136, 136, 136, 0.667);
		font-style: italic;
	}

	td {
		padding: 0.25rem 0;
	}
	tr td:first-child {
		font-weight: bold;
		padding-right: 2rem;
	}
</style>
