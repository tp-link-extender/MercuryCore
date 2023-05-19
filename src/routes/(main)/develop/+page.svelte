<script lang="ts">
	export let data
	const { user } = data
</script>

<svelte:head>
	<title>Develop - Mercury</title>
</svelte:head>

<div class="container py-2">
	<h1 class="h1 mb-2 text-light">Develop</h1>
	<div class="row">
		<div class="col-lg-2 col-md-3 mb-4">
			<ul class="nav nav-tabs flex-column border-0">
				<li class="nav-item mb-1" role="presentation">
					<a
						class="nav-link active"
						data-bs-toggle="tab"
						href="#create"
						aria-selected="true"
						role="tab">
						Create
					</a>
				</li>
				<li class="nav-item" role="presentation">
					<a
						class="nav-link"
						data-bs-toggle="tab"
						href="#creations"
						aria-selected="false"
						role="tab"
						tabindex="-1">
						Creations
					</a>
				</li>
			</ul>
		</div>
		<div id="myTabContent" class="tab-content col-lg-10 col-md-9">
			<div class="tab-pane fade active show" id="create" role="tabpanel">
				<div class="row">
					<a
						href="/develop/create?asset=11"
						class="col-lg-3 p-1 text-decoration-none">
						<div class="px-0 card bg-a3 text-center light-text">
							<div class="card-body bg-a rounded-1 p-4">
								<h1>🧥</h1>
								<h5 class="fw-normal mt-3">Shirts</h5>
							</div>
						</div>
					</a>

					<a
						href="/develop/create?asset=2"
						class="col-lg-3 p-1 text-decoration-none">
						<div class="px-0 card bg-a3 text-center light-text">
							<div class="card-body bg-a rounded-1 p-4">
								<h1>👕</h1>
								<h5 class="fw-normal mt-3">T-Shirts</h5>
							</div>
						</div>
					</a>

					<a
						href="/develop/create?asset=12"
						class="col-lg-3 p-1 text-decoration-none">
						<div class="px-0 card bg-a3 text-center light-text">
							<div class="card-body bg-a rounded-1 p-4">
								<h1>👖</h1>
								<h5 class="fw-normal mt-3">Pants</h5>
							</div>
						</div>
					</a>

					<a
						href="/develop/create?asset=13"
						class="col-lg-3 p-1 text-decoration-none">
						<div class="px-0 card bg-a3 text-center light-text">
							<div class="card-body bg-a rounded-1 p-4">
								<h1>🖼️</h1>
								<h5 class="fw-normal mt-3">Decals</h5>
							</div>
						</div>
					</a>

					{#if user?.permissionLevel == 5}
						<a
							href="/admin/stipend"
							class="col-lg-3 p-1 text-decoration-none">
							<div class="px-0 card bg-a3 text-center light-text">
								<div class="card-body bg-a rounded-1 p-4">
									<h1>🎩</h1>
									<h5 class="fw-normal mt-3">Hats</h5>
								</div>
							</div>
						</a>
					{/if}
				</div>
			</div>
			<div class="tab-pane fade" id="creations" role="tabpanel">
				<div class="row g-3">
					<a
						href="/admin/banners"
						class="col-lg-3 p-1 text-decoration-none">
						<div class="px-0 card bg-a3 text-center light-text">
							<div class="card-body bg-a rounded-1 p-4">
								<h1>🧥</h1>
								<h5 class="fw-normal mt-3">Shirts</h5>
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
								<h1>👕</h1>
								<h5 class="fw-normal mt-3">T-Shirts</h5>
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
								<h1>👖</h1>
								<h5 class="fw-normal mt-3">Pants</h5>
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
								<h1>🖼️</h1>
								<h5 class="fw-normal mt-3">Decals</h5>
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
									<h1>🎩</h1>
									<h5 class="fw-normal mt-3">Hats</h5>
									<small class="text-warning mb-0">
										0 of this asset created and approved
									</small>
								</div>
							</div>
						</a>
					{/if}
				</div>
			</div>
		</div>
	</div>
</div>

<style lang="sass">
	a .card-body
		transition: background-color 0.2s
		&:hover
			background-color: var(--background) !important

	.card
		border-width: 2px
		border-color: var(--accent3)

	.nav-tabs .nav-item.show .nav-link,
	.nav-tabs .nav-link.active 
		color: white
		background-color: rgb(13, 109, 252)
		border-color: var(--bs-nav-tabs-link-active-border-color)
		border-radius: 0.375rem

	.nav-link
		margin-bottom: calc(0 * var(--bs-nav-tabs-border-width))
		background: 0 0
		border: var(--bs-nav-tabs-border-width) solid transparent
		border-radius: 0.375rem
		color: var(--light-text)
</style>
