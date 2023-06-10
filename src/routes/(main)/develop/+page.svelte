<script lang="ts">
	import { Tab, TabNav, TabData } from "$lib/components/Tabs"

	export let data
	const { user } = data

	let tabData = TabData(data.url, ["Create", "Creations"])
</script>

<svelte:head>
	<title>Develop - Mercury</title>
</svelte:head>

<div class="container py-2">
	<h1 class="h1 mb-2 text-light">Develop</h1>
	<div class="grid grid-cols-12 gap-6">
		<div class="lg:col-span-2 md:col-span-3 mb-4">
			<TabNav bind:tabData tabs />
		</div>
		<div class="lg:col-span-10 md:col-span-9">
			<Tab {tabData}>
				<div class="grid grid-cols-12 gap-6">
					<a
						href="/develop/create?asset=11"
						class="lg:col-span-3 p-1 no-underline">
						<div class="px-0 card bg-a3 text-center light-text">
							<div class="card-body bg-a rounded-1 p-4">
								<span class="h1">🧥</span>
								<h2 class="font-normal h5 mt-3">Shirts</h2>
							</div>
						</div>
					</a>

					<a
						href="/develop/create?asset=2"
						class="lg:col-span-3 p-1 no-underline">
						<div class="px-0 card bg-a3 text-center light-text">
							<div class="card-body bg-a rounded-1 p-4">
								<span class="h1">👕</span>
								<h2 class="font-normal h5 mt-3">T-Shirts</h2>
							</div>
						</div>
					</a>

					<a
						href="/develop/create?asset=12"
						class="lg:col-span-3 p-1 no-underline">
						<div class="px-0 card bg-a3 text-center light-text">
							<div class="card-body bg-a rounded-1 p-4">
								<span class="h1">👖</span>
								<h2 class="font-normal h5 mt-3">Pants</h2>
							</div>
						</div>
					</a>

					<a
						href="/develop/create?asset=13"
						class="lg:col-span-3 p-1 no-underline">
						<div class="px-0 card bg-a3 text-center light-text">
							<div class="card-body bg-a rounded-1 p-4">
								<span class="h1">🖼️</span>
								<h2 class="font-normal h5 mt-3">Decals</h2>
							</div>
						</div>
					</a>

					{#if user?.permissionLevel == 5}
						<a
							href="/admin/stipend"
							class="lg:col-span-3 p-1 no-underline">
							<div class="px-0 card bg-a3 text-center light-text">
								<div class="card-body bg-a rounded-1 p-4">
									<span class="h1">🎩</span>
									<h2 class="font-normal h5 mt-3">Hats</h2>
								</div>
							</div>
						</a>
					{/if}
				</div>
			</Tab>
			<Tab {tabData}>
				<div class="grid grid-cols-12 gap-6">
					<a
						href="/admin/banners"
						class="lg:col-span-3 p-1 no-underline">
						<div class="px-0 card bg-a3 text-center light-text">
							<div class="card-body bg-a rounded-1 p-4">
								<span class="h1">🧥</span>
								<h2 class="font-normal h5 mt-3">Shirts</h2>
								<small class="text-warning mb-0">
									0 of this asset created and approved
								</small>
							</div>
						</div>
					</a>

					<a
						href="/admin/accounts"
						class="lg:col-span-3 p-1 no-underline">
						<div class="px-0 card bg-a3 text-center light-text">
							<div class="card-body bg-a rounded-1 p-4">
								<span class="h1">👕</span>
								<h2 class="font-normal h5 mt-3">T-Shirts</h2>
								<small class="text-warning mb-0">
									0 of this asset created and approved
								</small>
							</div>
						</div>
					</a>

					<a
						href="/admin/audit"
						class="lg:col-span-3 p-1 no-underline">
						<div class="px-0 card bg-a3 text-center light-text">
							<div class="card-body bg-a rounded-1 p-4">
								<span class="h1">👖</span>
								<h2 class="font-normal h5 mt-3">Pants</h2>
								<small class="text-warning mb-0">
									0 of this asset created and approved
								</small>
							</div>
						</div>
					</a>

					<a
						href="/admin/invites"
						class="lg:col-span-3 p-1 no-underline">
						<div class="px-0 card bg-a3 text-center light-text">
							<div class="card-body bg-a rounded-1 p-4">
								<span class="h1">🖼️</span>
								<h2 class="font-normal h5 mt-3">Decals</h2>
								<small class="text-warning mb-0">
									0 of this asset created and approved
								</small>
							</div>
						</div>
					</a>

					{#if user?.permissionLevel == 5}
						<a
							href="/admin/stipend"
							class="lg:col-span-3 p-1 no-underline">
							<div class="px-0 card bg-a3 text-center light-text">
								<div class="card-body bg-a rounded-1 p-4">
									<span class="h1">🎩</span>
									<h2 class="font-normal h5 mt-3">Hats</h2>
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

<style lang="sass">
	a .card-body
		transition: background-color 0.2s
		&:hover
			background-color: var(--background) !important

	.card
		border-width: 2px
		border-color: var(--accent3)
</style>
