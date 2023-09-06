<script lang="ts">
	const assetTypes = [
		["Shirts", "🧥", "11"],
		["T-Shirts", "👕", "2"],
		["Pants", "👖", "12"],
		["Decals", "🖼️", "13"],
	]

	export let data
	const { user } = data

	if (user?.permissionLevel == 5) assetTypes.push(["Hats", "🎩", ""])

	let tabData = TabData(data.url, ["Create", "Creations"])
</script>

<Head title="Create" />

<div class="container py-2">
	<h1 class="h1 mb-2 text-light">Develop</h1>
	<div class="row">
		<div class="col-lg-2 col-md-3 mb-4">
			<TabNav bind:tabData tabs />
		</div>
		<div class="col-lg-10 col-md-9">
			<Tab {tabData}>
				<div class="row">
					<a
						href="/develop/create?asset=11"
						class="col-lg-3 p-1 text-decoration-none">
						<div class="px-0 card bg-a3 text-center light-text">
							<div class="card-body bg-a rounded-1 p-4">
								<span class="h1">🧥</span>
								<h2 class="fw-normal h5 mt-3">Shirts</h2>
							</div>
						</div>
					</a>

					<a
						href="/develop/create?asset=2"
						class="col-lg-3 p-1 text-decoration-none">
						<div class="px-0 card bg-a3 text-center light-text">
							<div class="card-body bg-a rounded-1 p-4">
								<span class="h1">👕</span>
								<h2 class="fw-normal h5 mt-3">T-Shirts</h2>
							</div>
						</div>
					</a>

					<a
						href="/develop/create?asset=12"
						class="col-lg-3 p-1 text-decoration-none">
						<div class="px-0 card bg-a3 text-center light-text">
							<div class="card-body bg-a rounded-1 p-4">
								<span class="h1">👖</span>
								<h2 class="fw-normal h5 mt-3">Pants</h2>
							</div>
						</div>
					</a>

					<a
						href="/develop/create?asset=13"
						class="col-lg-3 p-1 text-decoration-none">
						<div class="px-0 card bg-a3 text-center light-text">
							<div class="card-body bg-a rounded-1 p-4">
								<span class="h1">🖼️</span>
								<h2 class="fw-normal h5 mt-3">Decals</h2>
							</div>
						</div>
					</a>

					{#if user?.permissionLevel == 5}
						<a
							href="/admin/stipend"
							class="col-lg-3 p-1 text-decoration-none">
							<div class="px-0 card bg-a3 text-center light-text">
								<div class="card-body bg-a rounded-1 p-4">
									<span class="h1">🎩</span>
									<h2 class="fw-normal h5 mt-3">Hats</h2>
								</div>
							</div>
						</a>
					{/if}
				</div>
			</Tab>

			<Tab {tabData}>
				<div class="row g-3">
					<a
						href="/admin/banners"
						class="col-lg-3 p-1 text-decoration-none">
						<div class="px-0 card bg-a3 text-center light-text">
							<div class="card-body bg-a rounded-1 p-4">
								<span class="h1">🧥</span>
								<h2 class="fw-normal h5 mt-3">Shirts</h2>
								<small class="text-warning mb-0">
									0 of this asset created and approved
								</small>
							</div>
						</div>
					</a>

					<a
						href="/admin/accounts"
						class="col-lg-3 p-1 text-decoration-none">
						<div class="px-0 card bg-a3 text-center light-text">
							<div class="card-body bg-a rounded-1 p-4">
								<span class="h1">👕</span>
								<h2 class="fw-normal h5 mt-3">T-Shirts</h2>
								<small class="text-warning mb-0">
									0 of this asset created and approved
								</small>
							</div>
						</div>
					</a>

					<a
						href="/admin/audit"
						class="col-lg-3 p-1 text-decoration-none">
						<div class="px-0 card bg-a3 text-center light-text">
							<div class="card-body bg-a rounded-1 p-4">
								<span class="h1">👖</span>
								<h2 class="fw-normal h5 mt-3">Pants</h2>
								<small class="text-warning mb-0">
									0 of this asset created and approved
								</small>
							</div>
						</div>
					</a>

					<a
						href="/admin/invites"
						class="col-lg-3 p-1 text-decoration-none">
						<div class="px-0 card bg-a3 text-center light-text">
							<div class="card-body bg-a rounded-1 p-4">
								<span class="h1">🖼️</span>
								<h2 class="fw-normal h5 mt-3">Decals</h2>
								<small class="text-warning mb-0">
									0 of this asset created and approved
								</small>
							</div>
						</div>
					</a>

					{#if user?.permissionLevel == 5}
						<a
							href="/admin/stipend"
							class="col-lg-3 p-1 text-decoration-none">
							<div class="px-0 card bg-a3 text-center light-text">
								<div class="card-body bg-a rounded-1 p-4">
									<span class="h1">🎩</span>
									<h2 class="fw-normal h5 mt-3">Hats</h2>
									<small class="text-warning mb-0">
										0 of this asset created and approved
									</small>
								</div>
							</div>
						</a>
					{/if}
				</div>
			</Tab>
		</div>
	</div>
</div>
