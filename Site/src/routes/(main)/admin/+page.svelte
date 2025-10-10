<script lang="ts">
	import AdminLink from "$components/AdminLink.svelte"
	import Head from "$components/Head.svelte"
	import SidebarShell from "$components/SidebarShell.svelte"
	import Tab from "$components/Tab.svelte"
	import TabData from "$components/TabData"
	import permissionLevels from "$lib/permissionLevels"

	const { data } = $props()

	const { user, totalmem, freemem } = data

	const perms = permissionLevels(user.permissionLevel)
	const _uno = [
		"fa-user",
		"fa-check",
		"fa-hammer",
		"fa-shield-alt",
		"fa-scale-balanced"
	]

	const panel: { [_: string]: [string, string, string][] } = $state({
		Moderation: [
			["User moderation", "moderation", "fa-user-slash"],
			["Abuse reports", "reports", "fa-flag"],
			["Asset approval", "asset", "fa-file-circle-check"],
			["Render queue", "renderqueue", "fa-file-image"]
		],
		Catalog: [["Asset creation", "create", "fa-file-circle-plus"]],
		Economy: [["Transactions", "transactions", "fa-money-bill-transfer"]]
	})
	const tabNames = ["Moderation", "Catalog", "Economy", "Statistics"]

	if (user.permissionLevel === 5) {
		panel.Administration = [
			["Banners", "banners", "fa-bullhorn"],
			["Accounts", "accounts", "fa-user"],
			["Audit logs", "audit", "fa-book"],
			["Registration keys", "regkeys", "fa-key"],
			["Gameservers", "gameservers", "fa-server"],
		]
		tabNames.unshift("Administration")
	}

	let tabData = $state(
		TabData(data.url, tabNames, [
			"fa-diamond-half-stroke",
			"fa-stamp",
			"fa-basket-shopping",
			"fa-coins",
			"fa-chart-mixed"
		])
	)

	const mbUsed = (totalmem - freemem) / 1e3 ** 2
	// they done let gbs in the door
	const gbUsed = mbUsed / 1e3
	const gbTotal = totalmem / 1e3 ** 3
</script>

<Head name={data.siteName} title="Admin" />

<div class="ctnr 2xl:p-0 max-w-340">
	<h1>Admin Panel</h1>
	<h2 class="text-xl pb-4">
		Your permission level is <span style="color: {perms[0]}">
			<fa class="{perms[1]} px-1"></fa>
			{perms[2]}
		</span>
	</h2>
	<hr />
</div>

<SidebarShell bind:tabData space class="max-w-340">
	{#each tabNames.slice(0, -1) as key}
		<Tab bind:tabData class="grid lg:grid-cols-4 gap-4">
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

	<Tab bind:tabData>
		<div class="grid lg:grid-cols-[7fr_5fr] gap-4">
			<div class="flex flex-col gap-4">
				<div class="card bg-a p-4">
					<h3>
						<fa fa-memory></fa>
						{gbUsed.toFixed(2)} / {gbTotal.toFixed(2)} GB
					</h3>
					<span class="pb-2">
						{Math.round(mbUsed)} MB is being used
					</span>
					<div class="flex rounded-2 bg-darker h-4">
						<div
							class="bg-emerald-600 rounded-2"
							role="progressbar"
							aria-valuenow={totalmem - freemem}
							aria-valuemin={0}
							aria-valuemax={totalmem}
							style="width: {((totalmem - freemem) / totalmem) *
								100}%;">
						</div>
					</div>
				</div>
			</div>
			<div class="flex flex-col gap-4">
				<div class="card bg-a p-4">
					<h3>
						<fa fa-user class="pr-2"></fa>
						Users
					</h3>
					<span>
						<b class="accent-text">0 users</b>
						are currently online
					</span>
				</div>
				<div class="card bg-a p-4">
					<h3>
						<fa fa-file class="pr-2"></fa>
						Assets
					</h3>
					<div>
						<fa fa-file-circle-minus class="text-yellow-500 pr-2">
						</fa>
						<b>0 assets</b>
						are currently pending
					</div>
					<div>
						<fa fa-file-circle-check class="text-emerald-600 pr-2">
						</fa>
						<b>0 assets</b>
						have been approved
					</div>
					<div>
						<fa fa-file-circle-xmark class="text-red-500 pr-2"></fa>
						<b>0 assets</b>
						have been denied
					</div>
					<div>
						<fa fa-folder-closed class="text-cyan-500 pr-2"></fa>
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
