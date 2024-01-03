<script lang="ts">
	export let data

	let tabData = TabData(data.url, ["Status", "Render Queue"])

	const online = new Date(data.status).getTime() > Date.now() - 35 * 1000,
		current = data.queue[0]
</script>

<Head title="Render Queue - Admin" />

<div class="ctnr pt-6 max-w-280 light-text">
	<h1>Admin - Render Queue</h1>
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
			<Tab {tabData}>
				<div class="<lg:flex flex-col lg:grid grid-cols-2 gap-2">
					<div class="card light-text pb-1">
						<div class="card-body">
							<h2 class="text-xl mb-0">Render Server</h2>
							<small class="pb-3">
								is <b class="text-emerald-6">active</b>
							</small>

							<div>
								<fa fa-image class="text-emerald-6 pr-1" />
								<b>0 renders</b>
								Completed
							</div>
							<div>
								<fa
									fa-bars-progress
									class="text-yellow-5 pr-1" />
								<b>0 renders</b>
								Pending
							</div>
							<div>
								<fa fa-image-slash class="text-red-5 pr-1" />
								<b>0 renders</b>
								Failed
							</div>
						</div>
					</div>
					<div class="card light-text">
						<div class="card-body">
							<h2 class="text-xl">Currently Rendering</h2>
							<table class="p-5 w-full bg-background rounded-2">
								<thead>
									<tr>
										<th scope="col">Task ID</th>
										<th scope="col">Render Type</th>
										<th scope="col">
											User/Asset Requested
										</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<th scope="row">{current.id}</th>
										<td>{current.type}</td>
										<td>
											{#if current.user}
												<User
													user={current.user}
													full
													thin />
											{:else if current.asset}
												{current.asset.name}
											{:else}
												Unknown
											{/if}
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</Tab>
			<Tab {tabData}>
				<table id="rendertable" class="w-full light-text">
					<thead>
						<tr>
							<th scope="col">Task id</th>
							<th scope="col">Render type</th>
							<th scope="col">User/Asset requested</th>
							<th scope="col">Status</th>
							<th scope="col">Time started</th>
							<th scope="col">Time completed</th>
						</tr>
					</thead>
					<tbody>
						{#each data.queue as task}
							<tr>
								<td>{task.id}</td>
								<td>{task.type}</td>
								{#if task.user}
									<td>
										<User user={task.user} full thin />
									</td>
								{:else if task.asset}
									<td>{task.asset.name}</td>
								{:else}
									<td>Unknown</td>
								{/if}
								<td>{task.status}</td>
								<td>
									{new Date(task.created).toLocaleString()}
								</td>
								<td>
									{task.completed
										? new Date(
												task.completed
											).toLocaleString()
										: "N/A"}
								</td>
							</tr>
						{/each}
					</tbody>
				</table>
			</Tab>
		</div>
	</div>
</div>

<style lang="stylus">
	// Change colour of every second row
	#rendertable 
		tbody tr:nth-child(2n-1)
			background var(--darker)

		td
			height 3rem

	.card
		border 1px solid var(--accent2)
</style>
