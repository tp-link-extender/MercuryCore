<script lang="ts">
	import { enhance } from "$app/forms"
	import Report from "$lib/components/Report.svelte"
	import Modal from "$lib/components/Modal.svelte"
	import { Tab, TabNav, TabData } from "$lib/components/Tabs"
	import { writable } from "svelte/store"

	export let data
	export let form
	const { user } = data
	let modal = writable(false)

	let tabData = TabData(data.url, ["Description", "Comments"])
</script>

<svelte:head>
	<title>{data.name} - Mercury</title>
</svelte:head>

<div class="container">
	<div class="row">
		<div class="carousel slide col-md mb-3" />
		<div class="flex col-md">
			<div class="card rounded-none mb-4">
				<div class="card-body">
					<h1 class="light-text">{data.name}</h1>
					<p class="light-text mt-2 mb-0">
						<b>By:</b>
						<a
							href="/user/{data.creator.number}"
							class="text-decoration-none">
							{data.creator.username}
						</a>
					</p>
					<p class="light-text mt-2 mb-0">
						<b>Type:</b> {data.type}  
					</p>
					<p class="light-text mt-2 mb-0">
						<b>Sold:</b> {data.sold} 
						<span class="float-end">
							<Report
								user={data.creator.username}
								url="/avatarshop/item/{data.id}" />
						</span>
					</p>
				</div>
			</div>
				<button
					name="action"
					on:click={() => modal.set(true)}
					id="buy"
					value="buy"
					class="btn btn-lg w-100 float-left mb-4 {data.owned
						? 'btn-secondary disabled'
						: user?.currency < data.price
						? 'btn-danger disabled'
						: 'btn-success'}">
						<h4 class="mb-0">
					{#if data.owned}
						<i class="fa fa-gem" />
						{data.price == 0 ? "Free" : data.price}
						<i class="fa fa-check" />
						Owned
					{:else if data.price == 0}
						Get
					{:else}
						Buy for <i class="fa fa-gem" />
						{data.price}
					{/if}
					</h4>
				</button>
				{#if data.owned}
					<button
						name="action"
						value="delete"
						class="btn btn-sm w-100 float-right btn-danger">
						[debug] delete from inventory
					</button>
				{:else if data.price != 0}
					<p class="light-text" id="notify">
						Funds will be deducted from your account immediately
						upon pressing the buy button.
					</p>
				{/if}
				<!-- {#if form?.msg}
					<p class="text-danger">{form.msg}</p>
				{/if} -->
		</div>
	</div>

	<div class="bg-a">
		<TabNav bind:tabData justify />
	</div>

	<Tab {tabData}>
		<p class="light-text">{data.description}</p>
	</Tab>

	<Tab {tabData}>
		<div class="row">
			{#each data.owners as owner}
				<a
					href="/user/{owner.number}"
					class="d-flex text-decoration-none py-2 col col-lg-3 col-md-4 col-sm-6">
					<div class="me-3 rounded-circle pfp bg-a">
						<img
							src="/api/avatar/{owner?.username}"
							alt={owner.username}
							class="rounded-circle rounded-top-0" />
					</div>
					<p class="light-text my-auto h5 me-4 text-truncate">
						{owner.username}
					</p>
				</a>
			{/each}
		</div>
	</Tab>

	<h1 class="h3 light-text">Recommended</h1>
</div>

<Modal {modal}>
	<div class="modal-body d-flex flex-column p-4">
			<h1 class="text-center h5 light-text">
				"{data.name}" is ready to play! Have fun!
			</h1>
			<a
				class="btn btn-success"
				href="https://setup.banland.xyz/MercuryPlayerLauncher.exe">
				Download 2013
			</a>
	</div>
</Modal>

<style lang="sass">
	:target
		display: block !important

	@media only screen and (min-width: 576px)
		.container
			width: 60rem

	#notify
		font-size: 0.8rem
		opacity: 0
		height: 0
		transform: translateY(-1.5rem)
		transition: all 0.2s ease-out

	#buy
		z-index: 5
		&:hover ~ #notify
			opacity: 1
			height: 1.5rem
			transform: none

	#notify
		pointer-events: none

	.pfp
		width: 3.5rem
		height: 3.5rem
		img
			width: 3.5rem
			height: 3.5rem
</style>
