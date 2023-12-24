<script lang="ts">
	export let data

	let tabData = TabData(data.url, ["Status", "Render Queue"])

	const online = new Date(data.status).getTime() > Date.now() - 35 * 1000,
		current = data.queue[0]
</script>

<Head title="Render Queue - Admin" />

<div class="ctnr py-6">
	<h1>Admin - Render Queue</h1>
	<a href="/admin" class="no-underline">
		<fa fa-caret-left />
		Back to panel
	</a>
	<div class="row pt-6">
		<div class="col-lg-2 col-md-3 mb-6">
			<TabNav bind:tabData vertical />
		</div>
		<div class="col-lg-10 col-md-9">
			<Tab {tabData}>
				<div class="row">
					<div class="col">
						<div class="card light-text pb-1">
							<div class="card-body">
								<h2 class="fs-3 mb-0">Render Server</h2>
								<small class="pb-3">
									is <strong class="text-success">
										active
									</strong>
								</small>

								<br />
								<span>
									<fa fa-image class="text-success pe-1" />
									Renders Completed:
								</span>
								<br />
								<span>
									<i
										class="fa fa-bars-progress text-warning pe-1" />
									Renders Pending:
								</span>
								<br />
								<span>
									<i
										class="fa fa-image-slash text-danger pe-1" />
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
</style>
