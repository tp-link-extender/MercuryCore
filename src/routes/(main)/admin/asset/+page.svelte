<script lang="ts">
	export let data

	let tabData = TabData(data.url, ["Asset Queue"])
</script>

<svelte:head>
	<title>Asset Approval - Admin - Mercury</title>
</svelte:head>

<div class="container py-4">
	<h1 class="light-text mb-0">Admin - Asset Approval</h1>
	<a href="/admin" class="text-decoration-none">
		<i class="fas fa-caret-left" />
		Back to panel
	</a>
	<div class="row mt-4">
		<div class="col-lg-2 col-md-3 mb-4">
			<TabNav bind:tabData tabs />
		</div>
		<div class="col-lg-10 col-md-9">
			<button type="button" class="btn btn-sm btn-danger mb-2">
				Deny all assets
			</button>
			<div class="row">
				<div
					class="col-xl-2 col-lg-3 col-md-4 col-sm-4 col-6 px-2 mb-2">
					<div class="card">
						<div class="card-body">
							<div class="text-center pb-3">
								<img
									alt="#"
									class="img-fluid"
									src="https://clipground.com/images/clipart-traffic-cone-7.png" />
							</div>
							<p class="m-0">testdecal</p>
							<p class="m-0">
								by: <a href="/" class="text-decoration-none">
									task
								</a>
							</p>
							<div
								class="btn-group mt-2"
								role="group"
								aria-label="Approve deny button group">
								<button
									type="button"
									class="btn btn-sm btn-success">
									Approve
								</button>
								<button
									type="button"
									class="btn btn-sm btn-danger">
									Deny
								</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
