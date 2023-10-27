<script lang="ts">
	export let data

	let tabData = TabData(data.url, ["Status", "Render Queue"])

	const online = new Date(data.status).getTime() > Date.now() - 35 * 1000,
		current = data.queue[0]
</script>

<Head title="Render Queue - Admin" />

<div class="container py-6">
	<h1 class="light-text mb-0">Admin - Render Queue</h1>
	<a href="/admin" class="text-decoration-none">
		<fa fa-caret-left />
		Back to panel
	</a>
	<div class="row mt-6">
		<div class="col-lg-2 col-md-3 mb-6">
			<TabNav bind:tabData vertical />
		</div>
		<div class="col-lg-10 col-md-9">
			<Tab {tabData}>
				<div class="row">
					<div class="col">
						<div class="card light-text mb-1">
							<div class="card-body">
								<h2 class="fs-3 mb-0">Render Server</h2>
								<small class="mb-3">
									is <strong class="text-success">
										active
									</strong>
								</small>

								<br />
								<span>
									<fa fa-image class="text-success me-1" />
									Renders Completed:
								</span>
								<br />
								<span>
									<i
										class="fa fa-bars-progress text-warning me-1" />
									Renders Pending:
								</span>
								<br />
								<span>
									<i
										class="fa fa-image-slash text-danger me-1" />
									Renders Failed:
								</span>
							</div>
						</div>
					</div>
					<div class="col">
						<div class="card light-text">
							<div class="card-body">
								<h2 class="fs-3">Currently Rendering</h2>
								<table
									class="p-5 w-100 bg-background rounded-2">
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
											{#if current.user}
												<User
													user={current.user}
													full
													thin />
											{:else if current.asset}
												<td>{current.asset.name}</td>
											{:else}
												<td>Unknown</td>
											{/if}
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
			</Tab>
			<Tab {tabData}>
				<table id="rendertable" class="w-100 light-text">
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
								<th scope="row">{task.id}</th>
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
								<td>N/A</td>
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
</style>
