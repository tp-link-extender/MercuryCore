<script lang="ts">
	import { enhance } from "$app/forms"
	import Report from "$lib/components/Report.svelte"
	import { Tab, TabNav, TabData } from "$lib/components/Tabs"

	export let data
	export let form
	const { user } = data

	// type script mont
	const likeEnhance = (e: any) => {
		const action = e.formData.get("action")

		if (action == "like") {
			data.likes = true

			if (data.dislikes) data.dislikeCount--
			data.dislikes = false
			data.likeCount++
		} else if (action == "dislike") {
			data.dislikes = true

			if (data.likes) data.likeCount--
			data.likes = false
			data.dislikeCount++
		} else if (action == "unlike") {
			data.likes = false
			data.likeCount--
		} else if (action == "undislike") {
			data.dislikes = false
			data.dislikeCount--
		}

		if (["like", "dislike", "unlike", "undislike"].includes(action))
			return () => {}
	}

	let tabData = TabData(data.url, ["Description", "Owners"])
</script>

<svelte:head>
	<title>{data.name} - Mercury</title>
</svelte:head>

<div class="container">
	<div class="grid grid-cols-12 gap-6">
		<div class="carousel slide col-md mb-3" />
		<div class="flex col-md">
			<div class="card rounded-none mb-4">
				<div class="card-body">
					<h2 class="light-text">{data.name}</h2>
					<p class="light-text mt-2 mb-0">
						<b>By</b>
						<a
							href="/user/{data.creator.number}"
							class="no-underline">
							{data.creator.username}
						</a>
					</p>
					<br />
					<p class="light-text mt-2 mb-0">
						{data.description}
						<span class="float-right">
							<Report
								user={data.creator.username}
								url="/avatarshop/item/{data.id}" />
						</span>
					</p>
				</div>
			</div>
			<form
				use:enhance={likeEnhance}
				class="self-center col px-0 mb-2"
				method="POST">
				<button
					name="action"
					id="buy"
					value="buy"
					class="btn btn-lg w-100 float-left {data.owned
						? 'btn-secondary disabled'
						: user?.currency < data.price
						? 'bg-red-500 disabled'
						: 'bg-emerald-600 hover:bg-emerald-800 text-white'}">
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
				</button>
				{#if data.owned}
					<button
						name="action"
						value="delete"
						class="btn btn-sm w-100 float-right bg-red-500">
						[debug] delete from inventory
					</button>
				{:else if data.price != 0}
					<p class="light-text" id="notify">
						Funds will be deducted from your account immediately
						upon pressing the buy button.
					</p>
				{/if}
				{#if form?.msg}
					<p class="text-red-500">{form.msg}</p>
				{/if}
				<div class="grid grid-cols-12 gap-6 mb-2 mt-3">
					<div class="col flex justify-start">
						<button
							name="action"
							value={data.likes ? "unlike" : "like"}
							class="btn btn-sm {data.likes
								? 'bg-emerald-600 hover:bg-emerald-800 text-white'
								: 'btn-outline-success'}">
							{#if data.likes}
								<i class="fa fa-thumbs-up" />
							{:else}
								<i class="far fa-thumbs-up" />
							{/if}
						</button>
					</div>
					<div class="col flex justify-end">
						<button
							name="action"
							value={data.dislikes ? "undislike" : "dislike"}
							class="btn btn-sm {data.dislikes
								? 'bg-red-500'
								: 'btn-outline-danger'}">
							{#if data.dislikes}
								<i class="fa fa-thumbs-down" />
							{:else}
								<i class="far fa-thumbs-down" />
							{/if}
						</button>
					</div>
				</div>
				<div class="progress rounded-pill" style="height: 3px">
					<div
						class="progress-bar bg-emerald-500"
						role="progressbar"
						aria-label="Likes"
						style="width: {(data.likeCount /
							(data.dislikeCount + data.likeCount || 1)) *
							100}%"
						aria-valuenow={data.likeCount}
						aria-valuemin={0}
						aria-valuemax={data.dislikeCount + data.likeCount} />
					<div
						class="progress-bar bg-red-500"
						role="progressbar"
						aria-label="Dislikes"
						style="width: {(data.dislikeCount /
							(data.dislikeCount + data.likeCount || 1)) *
							100}%"
						aria-valuenow={data.dislikeCount}
						aria-valuemin={0}
						aria-valuemax={data.dislikeCount + data.likeCount} />
				</div>
				<div class="grid grid-cols-12 gap-6">
					<div class="col flex justify-start">
						<span class="light-text mx-2">
							{data.likeCount} like{data.likeCount == 1
								? ""
								: "s"}
						</span>
					</div>
					<div class="col flex justify-end">
						<span class="light-text mx-2">
							{data.dislikeCount} dislike{data.dislikeCount == 1
								? ""
								: "s"}
						</span>
					</div>
				</div>
			</form>
		</div>
	</div>

	<div class="bg-a">
		<TabNav bind:tabData justify />
	</div>

	<Tab {tabData}>
		<p class="light-text">{data.description}</p>
	</Tab>

	<Tab {tabData}>
		<div class="grid grid-cols-12 gap-6">
			{#each data.owners as owner}
				<a
					href="/user/{owner.number}"
					class="flex no-underline py-2 col lg:col-span-3 md:col-span-4 sm:col-span-6">
					<div class="me-3 rounded-full pfp bg-a">
						<img
							src="/api/avatar/{owner?.username}"
							alt={owner.username}
							class="rounded-full rounded-top-0" />
					</div>
					<p class="light-text my-auto h5 me-4 truncate">
						{owner.username}
					</p>
				</a>
			{/each}
		</div>
	</Tab>
</div>

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
