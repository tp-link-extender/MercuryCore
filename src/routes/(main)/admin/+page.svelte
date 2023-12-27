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
			["Moderate User", "/admin/moderation", "fa fa-user-slash"],
			// ["Report Abuse", "#", "far fa-flag"],
			["Asset Approval", "/admin/asset", "fa fa-file-circle-check"],
			["Render Queue", "/admin/renderqueue", "fa fa-file-image"],
		],
		Economy: [
			// ["Award Currency", "#", "far fa-gem"],
			// ["Create New Asset", "#", "fa fa-file-circle-plus"],
			[
				"Transactions",
				"/admin/transactions",
				"fa fa-money-bill-transfer",
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
			["Banners", "/admin/banners", "fa fa-bullhorn"],
			["Accounts", "/admin/accounts", "far fa-user"],
			["Audit Logs", "/admin/audit", "fa fa-book"],
			["Invites", "/admin/invites", "fa fa-key"],
		]
	}

	const tabNames = ["Moderation", "Economy", "Statistics"]
	if (user?.permissionLevel == 5) tabNames.unshift("Administration")

	let tabData = TabData(data.url, tabNames)
</script>

<Head title="Admin" />

<div class="ctnr pt-6 max-w-340">
	<h1 class="light-text">Admin Panel</h1>
	<h2 class="fs-3 pb-4">
		Your permission level is <span
			style="color: {permissions[user?.permissionLevel][0]}">
			<fa class="{permissions[user?.permissionLevel][1]} px-1" />
			{permissions[user?.permissionLevel][2]}
		</span>
	</h2>
	<hr class="text-light" />
	<div class="row">
		<div class="col-lg-2 col-md-3 mb-6 pr-0">
			<TabNav bind:tabData vertical />
		</div>
		<div class="col-lg-10 col-md-9">
			{#each tabNames.slice(0, -1) as key}
				<Tab {tabData}>
					<div class="row">
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
				<div class="row">
					<div class="col-lg-7 col-md-7 flex flex-col gap-4 pb-4">
						<div class="card bg-a3 text-black shadow-none">
							<div class="card-body bg-a rounded-1">
								<h3 class="light-text">
									<fa fa-memory />
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
								<div
									class="flex bg-darker rounded-2"
									style="height: 1rem">
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
						<div class="card bg-a3 text-black shadow-none">
							<div class="card-body bg-a rounded-1">
								{#await diskSpace || getDiskSpace()}
									<h3 class="light-text">Loading...</h3>
								{:then disk}
									<h3 class="light-text">
										<fa fa-hard-drive class="pr-2" />
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
									<div
										class="flex bg-darker rounded-2"
										style="height: 1rem">
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
					<div class="col-lg-5 col-md-5 flex flex-col gap-4">
						<div class="card bg-a3 text-black shadow-none">
							<div class="card-body bg-a rounded-1">
								<h3 class="light-text">
									<far fa-user class="mr-2" />
									Users
								</h3>
								<span class="light-text">
									<b class="text-primary">0 users</b>
									are currently online
								</span>
							</div>
						</div>
						<div class="card bg-a3 text-black shadow-none">
							<div class="card-body bg-a rounded-1">
								<h3 class="light-text">
									<far fa-file class="mr-2" />
									Assets
								</h3>
								<span class="light-text">
									<i
										class="fa text-warning fa-file-circle-minus mr-2" />
									<b class="light-text">0 assets</b>
									are currently pending
								</span>
								<br />
								<span class="light-text">
									<i
										class="fa text-success fa-file-circle-check mr-2" />
									<b class="light-text">0 assets</b>
									have been approved
								</span>
								<br />
								<span class="light-text">
									<i
										class="fa text-danger fa-file-circle-xmark mr-2" />
									<b class="light-text">0 assets</b>
									have been disapproved
								</span>
								<br />
								<span class="light-text">
									<i
										class="fa text-info fa-folder-closed mr-2" />
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
		border 1px solid var(--accent2)
</style>
