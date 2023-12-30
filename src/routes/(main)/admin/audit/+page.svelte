<script lang="ts">
	export let data

	let tabData = TabData(data.url, ["Audit Logs"])
</script>

<Head title="Audit Logs - Admin" />

<div class="ctnr py-6">
	<h1 class="mb-0">Admin - Audit Logs</h1>
	<a href="/admin" class="no-underline">
		<fa fa-caret-left />
		Back to panel
	</a>
	<div class="row mt-6">
		<TabNav bind:tabData vertical class="col-lg-2 col-md-3 mb-6" />
		<div class="col-lg-10 col-md-9">
			<Tab {tabData} />
		</div>
	</div>
</div>
