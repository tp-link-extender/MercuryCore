<script lang="ts">
	const permissions = [
		[], // index from 1
		["white", "fa-user", "User"],
		["aqua", "fa-check", "Verified"],
		["violet", "fa-hammer", "Catalog Manager"],
		["orange", "fa-shield-alt", "Moderator"],
		["crimson", "fa-scale-balanced", "Administrator"],
	]

	const panel: { [k: string]: [string, string, string][] } = {
		Moderation: [
			["Moderate User", "/admin/moderation", "fas fa-user-slash"],
			// ["Report Abuse", "#", "far fa-flag"],
			["Asset Approval", "/admin/asset", "fas fa-file-circle-check"],
		],
		Economy: [
			// ["Award Currency", "#", "far fa-gem"],
			// ["Create New Asset", "#", "fas fa-file-circle-plus"],
			[
				"Transactions",
				"/admin/transactions",
				"fas fa-money-bill-transfer",
			],
		],
	}

	let diskSpace: {
		free: number
		size: number
	}
	async function getDiskSpace() {
		const jsonData = JSON.parse(
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
			free: jsonData[1],
			size: jsonData[2],
		})
	}

	export let data
	const { user } = data

	if (user?.permissionLevel == 5) {
		panel.Economy.push(["Daily Stipend", "/admin/stipend", "far fa-clock"])
		panel.Administration = [
			["Banners", "/admin/banners", "fas fa-bullhorn"],
			["Accounts", "/admin/accounts", "far fa-user"],
			["Audit Logs", "/admin/audit", "fas fa-book"],
			["Invites", "/admin/invites", "fas fa-key"],
		]
	}

	const tabNames = ["Moderation", "Economy", "Statistics"]
	if (user?.permissionLevel == 5) tabNames.unshift("Administration")

	let tabData = TabData(data.url, tabNames)
</script>

<Head title="Admin" />

<div class="container py-6">
	<h1 class="fs-2 light-text">Admin Panel</h1>
	<h2 class="fs-4 mb-6 border-bottom border-2 pb-4 light-text">
		Your permission level is: <span
			style="color: {permissions[user?.permissionLevel][0]}">
			<i class="fa {permissions[user?.permissionLevel][1]} me-1" />
			{permissions[user?.permissionLevel][2]}
		</span>
	</h2>
	<div class="row">
		<div class="col-lg-2 col-md-3 mb-6 pe-0">
			<TabNav bind:tabData vertical />
		</div>
		<div class="col-lg-10 col-md-9">
			{#each tabNames.slice(0, -1) as key}
				<Tab {tabData}>
					<div class="row g-3">
						{#each panel[key] as i, num}
							<AdminLink
								href={i[1]}
								iconClass={i[2]}
								{num}
								total={panel[key].length}
								name={i[0]} />
						{/each}
					</div>
				</Tab>
			{/each}

			<Tab {tabData}>
				<div class="row g-3 pt-1">
					<div class="col-lg-7 col-md-7 ps-1">
						<div class="card bg-a3 text-black mb-4">
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
								<span class="light-text pb-2">
									{Math.round(
										(data.totalmem - data.freemem) /
											1024 ** 2
									)} MB is being used
								</span>
								<div class="d-flex bg-darker rounded-2" style="height: 1rem">
									<div
										class="progress-bar-striped bg-success rounded-2"
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
						<div class="card bg-a3 text-black">
							<div class="card-body bg-a rounded-1">
								{#await diskSpace || getDiskSpace()}
									<h3 class="light-text">Loading...</h3>
								{:then disk}
									<h3 class="light-text">
										<i class="fas fa-hard-drive pe-2" />
										{(
											(disk.size - disk.free) /
											1024 ** 3
										).toFixed(2)} / {(
											disk.size /
											1024 ** 3
										).toFixed(2)} GB
									</h3>
									<span class="light-text pb-2">
										{Math.round(
											(disk.size - disk.free) / 1024 ** 2
										)} MB is being used
									</span>
									<div class="d-flex bg-darker rounded-2" style="height: 1rem">
										<div
											class="progress-bar-striped bg-primary rounded-2"
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
					<div class="col-lg-5 col-md-5 pe-1">
						<div class="card bg-a3 text-black mb-4">
							<div class="card-body bg-a rounded-1">
								<h3 class="light-text">
									<i class="far fa-user me-2" />
									Users
								</h3>
								<span class="light-text">
									<b class="text-primary">0 users</b>
									are currently online
								</span>
							</div>
						</div>
						<div class="card bg-a3 text-black mb-4">
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
										class="fas text-success fa-file-circle-check me-2" />
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

<style lang="stylus">
	h2
		border-color var(--accent3) !important

	.card
		border-width 2px
		border-color var(--accent3)
</style>
