<script lang="ts">
	import AdminLink from "#components/AdminLink.svelte"
	import Head from "#components/Head.svelte"
	import SidebarShell from "#components/SidebarShell.svelte"
	import Tab from "#components/Tab.svelte"
	import TabData from "#components/TabData.ts"
	import permissionLevels from "#lib/permissionLevels.ts"

	const { data } = $props()

	let { user, totalmem, freemem } = $derived(data)

	let perms = $derived(permissionLevels(user.permissionLevel))
	const _uno = [
		"fa-user",
		"fa-check",
		"fa-hammer",
		"fa-shield-alt",
		"fa-scale-balanced"
	]

	interface PanelLink {
		icon: string
		level: number
		name: string
		slug: string
	}

	interface PanelCategory {
		icon: string
		links: PanelLink[]
		name: string
	}

	// Each link is shown only when the user meets the level its target page authorises with
	const panelCategories: PanelCategory[] = [
		{
			icon: "fa-diamond-half-stroke",
			links: [
				{ icon: "fa-bullhorn", level: 5, name: "Banners", slug: "banners" },
				{ icon: "fa-user", level: 5, name: "Accounts", slug: "accounts" },
				{ icon: "fa-book", level: 5, name: "Audit logs", slug: "audit" },
				{ icon: "fa-key", level: 5, name: "Registration keys", slug: "regkeys" },
				{ icon: "fa-server", level: 5, name: "Gameservers", slug: "gameservers" },
				// FFlags has no server load yet, so it stays admin-only with the rest of this section
				{ icon: "fa-flag", level: 5, name: "FFlags", slug: "fflags" }
			],
			name: "Administration"
		},
		{
			icon: "fa-stamp",
			links: [
				{ icon: "fa-user-slash", level: 4, name: "User moderation", slug: "moderation" },
				{ icon: "fa-flag", level: 5, name: "Abuse reports", slug: "reports" },
				{ icon: "fa-file-circle-check", level: 3, name: "Asset approval", slug: "asset" },
				{ icon: "fa-file-image", level: 3, name: "Render queue", slug: "renderqueue" }
			],
			name: "Moderation"
		},
		{
			icon: "fa-basket-shopping",
			links: [
				{ icon: "fa-file-circle-plus", level: 3, name: "Asset creation", slug: "create" }
			],
			name: "Catalog"
		},
		{
			icon: "fa-coins",
			links: [
				{ icon: "fa-money-bill-transfer", level: 5, name: "Transactions", slug: "transactions" }
			],
			name: "Economy"
		}
	]

	const visibleCategories = panelCategories
		.map(({ icon, links, name }) => ({
			icon,
			links: links.filter(link => user.permissionLevel >= link.level),
			name
		}))
		.filter(category => category.links.length > 0)

	let tabData = $state(
		TabData(
			data.url,
			[...visibleCategories.map(category => category.name), "Statistics"],
			[...visibleCategories.map(category => category.icon), "fa-chart-mixed"]
		)
	)

	let mbUsed = $derived((totalmem - freemem) / 1e3 ** 2)
	// they done let gbs in the door
	let gbUsed = $derived(mbUsed / 1e3)
	let gbTotal = $derived(totalmem / 1e3 ** 3)
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
	{#each visibleCategories as category}
		<Tab bind:tabData class="grid lg:grid-cols-4 gap-4">
			{#each category.links as link, num}
				<AdminLink
					href="/admin/{link.slug}"
					iconClass={link.icon}
					{num}
					total={category.links.length}
					name={link.name} />
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
