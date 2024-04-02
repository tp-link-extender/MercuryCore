<script lang="ts">
	import SidebarShell from "$lib/components/SidebarShell.svelte"

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

	export let data
	const { user } = data

	const perms = permissions[user?.permissionLevel]

	if (user?.permissionLevel === 5) {
		panel.Economy.push(["Daily Stipend", "/admin/stipend", "far fa-clock"])
		panel.Administration = [
			["Banners", "/admin/banners", "fa fa-bullhorn"],
			["Accounts", "/admin/accounts", "far fa-user"],
			["Audit Logs", "/admin/audit", "fa fa-book"],
			["Invites", "/admin/invites", "fa fa-envelopes"]
		]
	}

	const tabNames = ["Moderation", "Catalog", "Economy", "Statistics"]
	if (user?.permissionLevel === 5) tabNames.unshift("Administration")

	let tabData = TabData(data.url, tabNames, [
		"fa fa-diamond-half-stroke",
		"fa fa-stamp",
		"fa fa-basket-shopping",
		"fa fa-coins",
		"fa fa-chart-mixed"
	])
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
						{((data.totalmem - data.freemem) / 1024 ** 3).toFixed(
							2
						)} / {(data.totalmem / 1024 ** 3).toFixed(2)} GB
					</h3>
					<span class="pb-2">
						{Math.round((data.totalmem - data.freemem) / 1024 ** 2)}
						MB is being used
					</span>
					<div class="flex bg-darker rounded-2" style="height: 1rem">
						<div
							class="progress-bar-striped bg-emerald-6 rounded-2"
							role="progressbar"
							aria-valuenow={data.totalmem - data.freemem}
							aria-valuemin={0}
							aria-valuemax={data.totalmem}
							style="width: {((data.totalmem - data.freemem) /
								data.totalmem) *
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

<style lang="stylus">
	h2
		border-color var(--accent3) !important

	.card
		border 1px solid var(--accent2)
</style>
