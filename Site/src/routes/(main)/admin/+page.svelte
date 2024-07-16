<script lang="ts">
	import AdminLink from "$lib/components/AdminLink.svelte"
	import Head from "$lib/components/Head.svelte"
	import SidebarShell from "$lib/components/SidebarShell.svelte"
	import Tab from "$lib/components/Tab.svelte"
	import TabData from "$lib/components/TabData"

	export let data

	const permissions = [
		[], // index from 1
		["white", "fa-user", "User"],
		["aqua", "fa-check", "Verified"],
		["violet", "fa-hammer", "Catalog Manager"],
		["orange", "fa-shield-alt", "Moderator"],
		["crimson", "fa-scale-balanced", "Administrator"]
	]

	const panel: { [k: string]: [string, string, string][] } = {
		Moderation: [
			["Moderate User", "/admin/moderation", "fa fa-user-slash"],
			// ["Report Abuse", "#", "far fa-flag"],
			["Asset Approval", "/admin/asset", "fa fa-file-circle-check"],
			["Render Queue", "/admin/renderqueue", "fa fa-file-image"]
		],
		Catalog: [["Create Asset", "/admin/create", "fa fa-file-circle-plus"]],
		Economy: [
			["Transactions", "/admin/transactions", "fa fa-money-bill-transfer"]
		]
	}

	const { user, totalmem, freemem } = data

	const perms = permissions[user.permissionLevel]
	const isAdmin = user.permissionLevel === 5
	if (isAdmin)
		panel.Administration = [
			["Banners", "/admin/banners", "fa fa-bullhorn"],
			["Accounts", "/admin/accounts", "far fa-user"],
			["Audit Logs", "/admin/audit", "fa fa-book"],
			["Invites", "/admin/invites", "fa fa-envelopes"]
		]

	const tabNames = ["Moderation", "Catalog", "Economy", "Statistics"]
	if (isAdmin) tabNames.unshift("Administration")

	let tabData = TabData(data.url, tabNames, [
		"fa fa-diamond-half-stroke",
		"fa fa-stamp",
		"fa fa-basket-shopping",
		"fa fa-coins",
		"fa fa-chart-mixed"
	])

	const mbUsed = (totalmem - freemem) / 1e3 ** 2
	// they done let gbs in the door
	const gbUsed = mbUsed / 1e3
	const gbTotal = totalmem / 1e3 ** 3
</script>

<Head title="Admin" />

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
					href={i[1]}
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
						<far fa-user class="pr-2" />
						Users
					</h3>
					<span>
						<b class="accent-text">0 users</b>
						are currently online
					</span>
				</div>
				<div class="card bg-a p-4">
					<h3>
						<far fa-file class="pr-2" />
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
