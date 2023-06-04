<script lang="ts">
	import { Tab, TabNav, TabData } from "$lib/components/Tabs"

	const permissions = [
		[], // index from 1
		["white", "fa-user", "User"],
		["aqua", "fa-check", "Verified"],
		["violet", "fa-hammer", "Catalog Manager"],
		["orange", "fa-shield-alt", "Moderator"],
		["crimson", "fa-scale-balanced", "Administrator"],
	]

	let diskSpace: any
	async function getDiskSpace() {
		const data = JSON.parse(
			(
				await (
					await fetch("admin", {
						body: "",
						method: "POST",
					})
				).json()
			).data
		)
		return (diskSpace = {
			free: data[1],
			size: data[2],
		})
	}

	export let data
	const { user } = data

	const tabNames = ["Moderation", "Economy", "Statistics"]
	let pos = 1
	if (user?.permissionLevel == 5) {
		tabNames.unshift("Administration")
		pos = 0
	}

	let tabData = TabData(data.url, tabNames)
</script>

<svelte:head>
	<title>Admin - Mercury</title>
</svelte:head>

<div class="container py-4">
	<h1 class="h2 light-text">Admin Panel</h1>
	<h2 class="h4 mb-4 border-bottom border-2 pb-3 light-text">
		Your permission level is: <span
			style="color: {permissions[user?.permissionLevel][0]}">
			<i class="fa {permissions[user?.permissionLevel][1]} me-1" />
			{permissions[user?.permissionLevel][2]}
		</span>
	</h2>
	<div class="row">
		<div class="col-lg-2 col-md-3 mb-4 pe-0">
			<TabNav bind:tabData tabs />
		</div>
		<div class="col-lg-10 col-md-9">
			{#if user?.permissionLevel == 5}
				<Tab {tabData}>
					<div class="row">
						<a
							href="/admin/banners"
							class="col-lg-3 p-1 no-underline">
							<div class="px-0 card bg-a3 text-center light-text">
								<div class="card-body bg-a rounded-1 p-4">
									<h1>
										<i class="fas fa-bullhorn" />
									</h1>
									<h5 class="font-normal mt-3">Banners</h5>
								</div>
							</div>
						</a>

						<a
							href="/admin/accounts"
							class="col-lg-3 p-1 no-underline">
							<div class="px-0 card bg-a3 text-center light-text">
								<div class="card-body bg-a rounded-1 p-4">
									<h1>
										<i class="far fa-user" />
									</h1>
									<h5 class="font-normal mt-3">Accounts</h5>
								</div>
							</div>
						</a>

						<a
							href="/admin/audit"
							class="col-lg-3 p-1 no-underline">
							<div class="px-0 card bg-a3 text-center light-text">
								<div class="card-body bg-a rounded-1 p-4">
									<h1>
										<i class="fas fa-book" />
									</h1>
									<h5 class="font-normal mt-3">Audit Logs</h5>
								</div>
							</div>
						</a>

						<a
							href="/admin/invites"
							class="col-lg-3 p-1 no-underline">
							<div class="px-0 card bg-a3 text-center light-text">
								<div class="card-body bg-a rounded-1 p-4">
									<h1>
										<i class="fas fa-key" />
									</h1>
									<h5 class="font-normal mt-3">Invites</h5>
								</div>
							</div>
						</a>

						<!-- <a href="#" class="col-lg-3 p-1 no-underline" 
							><div class="px-0 card bg-a3 text-center light-text">
								<div class="card-body bg-a rounded-1 p-4">
									<h1>
										<i class="fas fa-dice" />
									</h1>
									<h5 class="font-normal mt-3">Coin Flip</h5>
								</div>
							</div>
						</a> -->
					</div>
				</Tab>
			{/if}
			<Tab {tabData}>
				<div class="row">
					<a
						href="/admin/moderation"
						class="col-lg-3 p-1 no-underline">
						<div class="px-0 card bg-a3 text-center light-text">
							<div class="card-body bg-a rounded-1 p-4">
								<h1>
									<i class="fas fa-user-slash" />
								</h1>
								<h5 class="font-normal mt-3">Moderate User</h5>
							</div>
						</div>
					</a>

					<!-- <a href="#" class="col-lg-3 p-1 no-underline"
						><div class="px-0 card bg-a3 text-center light-text">
							<div class="card-body bg-a rounded-1 p-4">
								<h1>
									<i class="far fa-flag" />
								</h1>
								<h5 class="font-normal mt-3">Report Abuse</h5>
							</div>
						</div>
						 </a> -->

					<!-- <a href="#" class="col-lg-3 p-1 no-underline"
						><div class="px-0 card bg-a3 text-center light-text">
							<div class="card-body bg-a rounded-1 p-4">
								<h1>
									<i class="fas fa-file-circle-check" />
								</h1>
								<h5 class="font-normal mt-3">Asset Approval</h5>
							</div>
						</div>
						</a> -->
				</div>
			</Tab>

			<Tab {tabData}>
				<div class="row">
					{#if user?.permissionLevel == 5}
						<a
							href="/admin/stipend"
							class="col-lg-3 p-1 no-underline">
							<div class="px-0 card bg-a3 text-center light-text">
								<div class="card-body bg-a rounded-1 p-4">
									<h1>
										<i class="far fa-clock" />
									</h1>
									<h5 class="font-normal mt-3">
										Daily Stipend
									</h5>
								</div>
							</div>
						</a>
					{/if}

					<!-- <a href="#" class="col-lg-3 p-1 no-underline"
						><div class="px-0 card bg-a3 text-center light-text">
							<div class="card-body bg-a rounded-1 p-4">
								<h1><i class="far fa-gem" /></h1>
								<h5 class="font-normal mt-3">Award Currency</h5>
							</div>
						</div>
						</a> -->
					<!-- {#if user?.permissionLevel == 5 || user?.permissionLevel == 3}
						<a href="#" class="col-lg-3 p-1 no-underline"
							><div class="px-0 card bg-a3 text-center light-text">
								<div class="card-body bg-a rounded-1 p-4">
									<h1>
										<i class="fas fa-file-circle-plus" />
									</h1>
									<h5 class="font-normal mt-3">
										Create New Asset
									</h5>
								</div>
							</div>
							</a>
					{/if} -->

					<a
						href="/admin/transactions"
						class="col-lg-3 p-1 no-underline">
						<div class="px-0 card bg-a3 text-center light-text">
							<div class="card-body bg-a rounded-1 p-4">
								<h1>
									<i class="fas fa-money-bill-transfer" />
								</h1>
								<h5 class="font-normal mt-3">Transactions</h5>
							</div>
						</div>
					</a>
				</div>
			</Tab>

			<Tab {tabData}>
				<div class="row">
					<div class="col-lg-7 col-md-7">
						<div class="card bg-a3 text-black mb-3">
							<div class="card-body bg-a rounded-1">
								<h3 class="light-text">
									<i class="fas fa-memory" />
									{(
										(data.totalmem - data.freemem) /
										1024 ** 3
									).toFixed(2)} / {(
										data.totalmem /
										1024 ** 3
									).toFixed(2)} GB
								</h3>
								<span class="light-text">
									{Math.round(
										(data.totalmem - data.freemem) /
											1024 ** 2
									)} MB is being used
								</span>
								<div class="progress bg-darker mt-2">
									<div
										class="progress-bar progress-bar-striped progress-bar-animated bg-success"
										role="progressbar"
										aria-valuenow={data.totalmem -
											data.freemem}
										aria-valuemin={0}
										aria-valuemax={data.totalmem}
										style="width: {((data.totalmem -
											data.freemem) /
											data.totalmem) *
											100}%;" />
								</div>
							</div>
						</div>
						<div class="card bg-a3 text-black mb-3">
							<div class="card-body bg-a rounded-1">
								{#await diskSpace || getDiskSpace()}
									<h3 class="light-text">Loading...</h3>
								{:then disk}
									<h3 class="light-text">
										<i class="fas fa-hard-drive me-2" />
										{(
											(disk.size - disk.free) /
											1024 ** 3
										).toFixed(2)} / {(
											disk.size /
											1024 ** 3
										).toFixed(2)} GB
									</h3>
									<span class="light-text">
										{Math.round(
											(disk.size - disk.free) / 1024 ** 2
										)} MB is being used
									</span>
									<div class="progress bg-darker mt-2">
										<div
											class="progress-bar progress-bar-striped progress-bar-animated"
											role="progressbar"
											aria-valuenow={disk.size -
												disk.free}
											aria-valuemin={0}
											aria-valuemax={disk.size}
											style="width: {((disk.size -
												disk.free) /
												disk.size) *
												100}%;" />
									</div>
								{/await}
							</div>
						</div>
					</div>
					<div class="col-lg-5 col-md-5">
						<div class="card bg-a3 text-black mb-3">
							<div class="card-body bg-a rounded-1">
								<h3 class="light-text">
									<i class="far fa-user me-2" />
									Users
								</h3>
								<span class="light-text">
									<b class="text-blue-500">0 users</b>
									are currently online
								</span>
							</div>
						</div>
						<div class="card bg-a3 text-black mb-3">
							<div class="card-body bg-a rounded-1">
								<h3 class="light-text">
									<i class="far fa-file me-2" />
									Assets
								</h3>
								<span class="light-text">
									<i
										class="fas text-warning fa-file-circle-minus me-2" />
									<b class="light-text">0 assets</b>
									are currently pending
								</span>
								<br />
								<span class="light-text">
									<i
										class="fas text-emerald-500 fa-file-circle-check me-2" />
									<b class="light-text">0 assets</b>
									have been approved
								</span>
								<br />
								<span class="light-text">
									<i
										class="fas text-danger fa-file-circle-xmark me-2" />
									<b class="light-text">0 assets</b>
									have been disapproved
								</span>
								<br />
								<span class="light-text">
									<i
										class="fas text-info fa-folder-closed me-2" />
									<b class="light-text">0 assets</b>
									in total
								</span>
							</div>
						</div>
					</div>
				</div>
			</Tab>
		</div>
	</div>
</div>

<style lang="sass">
	h2
		border-color: var(--accent3) !important

	a .card-body
		transition: background-color 0.2s
		&:hover
			background-color: var(--background) !important

	.card
		border-width: 2px
		border-color: var(--accent3)
</style>
