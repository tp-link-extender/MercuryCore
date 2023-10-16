<script lang="ts">
	export let data

	let tabData = TabData(data.url, ["Status", "Render Queue"])
</script>

<Head title="Render Queue - Admin" />

<div class="container py-6">
	<h1 class="light-text mb-0">Admin - Render Queue</h1>
	<a href="/admin" class="text-decoration-none">
		<i class="fas fa-caret-left" />
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
										online
									</strong>
								</small>

								<br />
								<span>
									<i class="fas fa-clock text-primary me-1" />
									Last Checked:
								</span>
								<br />
								<span>
									<i class="fas fa-image text-success me-1" />
									Renders Completed:
								</span>
								<br />
								<span>
									<i
										class="fas fa-bars-progress text-warning me-1" />
									Renders Pending:
								</span>
								<br />
								<span>
									<i
										class="fas fa-image-slash text-danger me-1" />
									Renders Failed:
								</span>
							</div>
						</div>
					</div>
					<div class="col">
						<div class="card light-text">
							<div class="card-body">
								<h2 class="fs-3">Currently Rendering</h2>
								<table class="table w-100">
									<thead>
										<tr>
											<th scope="col">Task ID</th>
											<th scope="col">Render Type</th>
											<th scope="col">User/Asset Requested</th>
										</tr>
									</thead>
									<tbody>
										<tr class="table-active">
											<th scope="row">1</th>
											<td>Avatar</td>
											<td>Heliodex</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
			</Tab>
            <Tab {tabData}>
                <table class="table w-100 light-text">
                    <thead>
                        <tr>
                            <th scope="col">Task ID</th>
                            <th scope="col">Render Type</th>
                            <th scope="col">User/Asset Requested</th>
                            <th scope="col">Status</th>
                            <th scope="col">Time Completed</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="table-active">
                            <th scope="row">1</th>
                            <td>Avatar</td>
                            <td>Heliodex</td>
                            <td>Pending</td>
                            <td>N/A</td>
                        </tr>
                    </tbody>
                </table>
            </Tab>
		</div>
	</div>
</div>
