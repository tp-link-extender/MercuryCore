<script lang="ts">
	export let data

	let tabData = TabData(data.url, ["Audit Logs"])
</script>

<Head title="Audit Logs - Admin" />

<div class="container py-6">
	<h1 class="light-text mb-0">Admin - Audit Logs</h1>
	<a href="/admin" class="text-decoration-none">
		<i class="fas fa-caret-left" />
		Back to panel
	</a>
	<div class="row mt-4">
		<div class="col-lg-2 col-md-3 mb-4">
			<TabNav bind:tabData tabs />
		</div>
		<div class="col-lg-10 col-md-9">
			<Tab {tabData} />
		</div>
	</div>
</div>
