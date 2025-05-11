<script lang="ts">
	import { applyAction } from "$app/forms"
	import { enhance } from "$app/forms"
	import { invalidateAll } from "$app/navigation"
	import Comment from "$components/Comment.svelte"
	import Head from "$components/Head.svelte"
	import PostReply from "$components/PostReply.svelte"
	import Tab from "$components/Tab.svelte"
	import TabData from "$components/TabData"
	import TabNav from "$components/TabNav.svelte"
	import User from "$components/User.svelte"
	import types from "$lib/assetTypes"
	import { superForm } from "sveltekit-superforms/client"

	let replyingTo = $state("")
	let commentsCollapsed = $state({})

	const { data, form } = $props()

	const { user } = data
	const fee = (data.currentFee * data.asset.price).toFixed(2)
	const totalPrice = (1 + data.currentFee) * data.asset.price
	const itsFree = data.asset.price === 0 // IT'S FREEEEEEEEEEEEEE

	let regenerating = $state(false)

	const enhanceRegen: import("./$types").SubmitFunction = () => {
		regenerating = true
		return async ({ result }) => {
			if (result.type === "success") await invalidateAll()
			await applyAction(result)
			regenerating = false
		}
	}

	let comments = $state(data.asset.comments)
	$effect(() => {
		comments = data.asset.comments
	})

	const formData = superForm(data.form)

	let tabData = $state(TabData(data.url, ["Recommended", "Comments"]))
</script>

<Head name={data.siteName} title={data.asset.name} />

<div class="ctnr max-w-240">
	<div class="flex <sm:flex-col">
		<div class="pr-4 pb-4">
			<img
				class={[
					"image transition-opacity duration-300 aspect-1 w-80vw max-w-100",
					{ "opacity-50": regenerating }
				]}
				src={form?.icon ||
					`/catalog/${data.asset.id}/${data.slug}/icon`}
				alt={data.asset.name} />
		</div>
		<div class="light-text w-full">
			<div class="flex justify-between">
				<h1>{data.asset.name}</h1>
				{#if user.permissionLevel >= 5 && [8, 11, 12].includes(data.asset.type)}
					<span class="dropdown pl-2 pt-2">
						<fa fa-ellipsis-h class="dropdown-ellipsis"></fa>
						<div class="dropdown-content">
							<ul class="p-2 rounded-3">
								<li class="rounded-2">
									<form
										use:enhance={enhanceRegen}
										method="POST"
										action="?/rerender">
										<button
											class="btn accent-text pl-4 pr-0 text-start">
											<fa fa-arrows-rotate class="pr-2">
											</fa>
											<b>Rerender</b>
										</button>
									</form>
								</li>
							</ul>
						</div>
					</span>
				{/if}
			</div>
			<div class="flex">
				<strong class="pr-2">by:</strong>

				{#if data.asset.creator}
					<User
						user={data.asset.creator}
						size="1.5rem"
						full
						thin
						bg="accent" />
				{/if}
			</div>
			<p class="pt-2">
				{#if data.asset.description}
					{data.asset.description.text}
				{:else}
					<em>No description available</em>
				{/if}
			</p>

			<hr />
			<div class="flex flex-wrap pb-2">
				<div class="w-full md:w-1/3">
					<p class="pb-2">
						<strong>{data.asset.sold}</strong>
						sold
					</p>
					<p>
						<strong>Type</strong>
						{types[data.asset.type]}
					</p>
				</div>
				<div class="w-full md:w-2/3 flex flex-row-reverse">
					<div class="card light-text p-4">
						{#if itsFree}
							<b class="pb-2">Free</b>
						{:else}
							<table>
								<tbody>
									<tr>
										<td>Price</td>
										<td class="text-emerald-600">
											{data.currencySymbol}
											{data.asset.price}
										</td>
									</tr>
									<tr>
										<td>Fee</td>
										<td class="text-yellow-500">
											{data.currencySymbol}
											{fee}
										</td>
									</tr>
								</tbody>
							</table>
						{/if}
						{#if !data.asset.owned}
							<button popovertarget="buy" class="btn btn-success">
								<strong class="text-xl">
									{itsFree ? "Get" : "Buy now"}
								</strong>
							</button>
						{:else}
							<strong
								class="btn btn-dark bg-a3 pointer-events-none text-xl">
								Owned
							</strong>
						{/if}
					</div>
				</div>
			</div>
		</div>
	</div>

	<TabNav bind:tabData justify />

	<Tab bind:tabData />

	<Tab bind:tabData class={{ "pb-32": comments.length > 0 }}>
		<PostReply {formData} />
		{#if comments.length > 0}
			{#each comments as _, num}
				<Comment
					bind:comment={comments[num]}
					{num}
					bind:commentsCollapsed
					bind:replyingTo
					{user} />
			{/each}
		{:else}
			<h3 class="text-center pt-6">
				No comments yet. Be the first to post one!
			</h3>
		{/if}
	</Tab>
</div>

<div id="buy" class="light-text p-4 min-w-120" popover="auto">
	{#if data.balance >= totalPrice}
		<h3 class="text-lg font-bold">Purchase {data.asset.name}</h3>
		<p class="pb-4">
			Would you like to {itsFree ? "get" : "buy"}
			{data.asset.name} for
			{#if itsFree}
				<strong>FREE?</strong>
			{:else}
				{data.currencySymbol}
				{totalPrice}
				?
			{/if}
		</p>

		<form method="POST" action="?/buy" class="inline">
			<button class="btn btn-success">
				{itsFree ? "Get" : "Buy now"}
			</button>
		</form>
		<button
			popovertarget="buy"
			popovertargetaction="hide"
			class="btn btn-dark ml-2">
			{data.noText}
		</button>
	{:else}
		<h3 class="text-lg font-bold">Insufficient funds</h3>
		<span>
			You don't have enough {data.currencySymbol} to buy this item.
		</span>
		<p>
			You'll need <strong>
				{totalPrice - data.balance}
			</strong>
			more.
		</p>

		<button
			popovertarget="buy"
			popovertargetaction="hide"
			class="btn btn-dark">
			{data.failText}
		</button>
	{/if}
</div>

<style>
	.image {
		background: var(--accent1);
		background-image: linear-gradient(
				45deg,
				var(--darker) 25%,
				transparent 25%,
				transparent 75%,
				var(--darker) 75%
			),
			linear-gradient(
				45deg,
				var(--darker) 25%,
				transparent 25%,
				transparent 75%,
				var(--darker) 75%
			);
		background-size: 20px 20px;
		background-position:
			0 0,
			10px 10px;
	}

	td {
		padding: 0;
		&:first-child {
			padding-right: 0.5rem;
		}
	}
</style>
