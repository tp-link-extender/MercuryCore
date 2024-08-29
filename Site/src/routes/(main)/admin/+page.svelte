<script lang="ts">
	import AdminLink from "$components/AdminLink.svelte"
	import Head from "$components/Head.svelte"
	import SidebarShell from "$components/SidebarShell.svelte"
	import Tab from "$components/Tab.svelte"
	import TabData from "$components/TabData"
	import permissionLevels from "$lib/permissionLevels"

	export let data

	const { user, totalmem, freemem } = data

	const perms = permissionLevels(user.permissionLevel)
	const _uno = [
		"fa-user",
		"fa-check",
		"fa-hammer",
		"fa-shield-alt",
		"fa-scale-balanced"
	]

	const panel: { [k: string]: [string, string, string][] } = {
		Moderation: [
			["Moderate User", "/admin/moderation", "fa-user-slash"],
			["Abuse reports", "/admin/reports", "fa-flag"],
			["Asset Approval", "/admin/asset", "fa-file-circle-check"],
			["Render Queue", "/admin/renderqueue", "fa-file-image"]
		],
		Catalog: [["Create Asset", "/admin/create", "fa-file-circle-plus"]],
		Economy: [
			["Transactions", "/admin/transactions", "fa-money-bill-transfer"]
		]
	}
	const tabNames = ["Moderation", "Catalog", "Economy", "Statistics"]

	if (user.permissionLevel === 5) {
		panel.Administration = [
			["Banners", "banners", "fa-bullhorn"],
			["Accounts", "accounts", "fa-user"],
			["Audit Logs", "audit", "fa-book"],
			["Registration Keys", "regkeys", "fa-key"]
		]
		tabNames.unshift("Administration")
	}

	let tabData = TabData(data.url, tabNames, [
		"fa-diamond-half-stroke",
		"fa-stamp",
		"fa-basket-shopping",
		"fa-coins",
		"fa-chart-mixed"
	])

	const mbUsed = (totalmem - freemem) / 1e3 ** 2
	// they done let gbs in the door
	const gbUsed = mbUsed / 1e3
	const gbTotal = totalmem / 1e3 ** 3
</script>

<Head name={data.siteName} title="Admin" />

<div class="ctnr max-w-340">
	<h1>Admin Panel</h1>
	<h2 class="text-xl pb-4">
		Your permission level is <span style="color: {perms[0]}">
			<fa class="{perms[1]} px-1" />
			{perms[2]}
		</span>
	</h2>
	<hr />
</div>

<SidebarShell bind:tabData class="max-w-340">
	{#each tabNames.slice(0, -1) as key}
		<Tab {tabData} class="grid lg:grid-cols-4 gap-4">
			{#each panel[key] as i, num}
				<AdminLink
					href="/admin/{i[1]}"
					iconClass={i[2]}
					{num}
					total={panel[key].length}
					name={i[0]} />
			{/each}
		</Tab>
	{/each}

	<Tab {tabData}>
		<div class="grid lg:grid-cols-[7fr_5fr] gap-4">
			<div class="flex flex-col gap-4">
				<div class="card bg-a p-4">
					<h3>
						<fa fa-memory />
						{gbUsed.toFixed(2)} / {gbTotal.toFixed(2)} GB
					</h3>
					<span class="pb-2">
						{Math.round(mbUsed)} MB is being used
					</span>
					<div class="flex rounded-2 bg-darker h-4">
						<div
							class="bg-emerald-6 rounded-2"
							role="progressbar"
							aria-valuenow={totalmem - freemem}
							aria-valuemin={0}
							aria-valuemax={totalmem}
							style="width: {((totalmem - freemem) / totalmem) *
								100}%;" />
					</div>
				</div>
			</div>
			<div class="flex flex-col gap-4">
				<div class="card bg-a p-4">
					<h3>
						<fa fa-user class="pr-2" />
						Users
					</h3>
					<span>
						<b class="accent-text">0 users</b>
						are currently online
					</span>
				</div>
				<div class="card bg-a p-4">
					<h3>
						<fa fa-file class="pr-2" />
						Assets
					</h3>
					<div>
						<fa fa-file-circle-minus class="text-yellow-5 pr-2" />
						<b>0 assets</b>
						are currently pending
					</div>
					<div>
						<fa fa-file-circle-check class="text-emerald-6 pr-2" />
						<b>0 assets</b>
						have been approved
					</div>
					<div>
						<fa fa-file-circle-xmark class="text-red-5 pr-2" />
						<b>0 assets</b>
						have been denied
					</div>
					<div>
						<fa fa-folder-closed class="text-cyan-5 pr-2" />
						<b>0 assets</b>
						in total
					</div>
				</div>
			</div>
		</div>
	</Tab>
</SidebarShell>

<style>
	h2 {
		border-color: var(--accent3) !important;
	}

	.card {
		border: 1px solid var(--accent2);
	}
</style>
