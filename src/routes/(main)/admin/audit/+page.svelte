<script lang="ts">
	export let data

	let tabData = TabData(data.url, ["Audit Logs"])
</script>

<Head title="Audit Logs - Admin" />

<div class="ctnr pt-6">
	<h1>Admin - Audit Logs</h1>
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
			<Tab {tabData} />
		</div>
	</div>
</div>
