<script lang="ts">
	export let data

	let tabData = TabData(data.url, ["Audit logs"], ["fa fa-list"])
</script>

<Head title="Audit logs - Admin" />

<div class="flex px-4">
	<div class="<lg:hidden w-75" />
	<div class="flex w-full justify-center">
		<div class="w-full max-w-240 <md:px-4">
			<h1>Admin - Audit logs</h1>
			<a href="/admin" class="no-underline">
				<fa fa-caret-left />
				Back to panel
			</a>
		</div>
		<div class="<lg:hidden shrink-9999 w-75" />
	</div>
</div>

<div class="px-4 pt-6">
	<SidebarShell bind:tabData>
		<Tab {tabData} />
	</SidebarShell>
</div>
