<script lang="ts">
	import { applyAction } from "$app/forms"
	import { enhance } from "$app/forms"
	import { invalidateAll } from "$app/navigation"
	import ForumReply from "$components/ForumReply.svelte"
	import Head from "$components/Head.svelte"
	import PostReply from "$components/PostReply.svelte"
	import Tab from "$components/Tab.svelte"
	import TabData from "$components/TabData"
	import TabNav from "$components/TabNav.svelte"
	import User from "$components/User.svelte"
	import types from "$lib/assetTypes"
	import { writable } from "svelte/store"
	import { superForm } from "sveltekit-superforms/client"

	export let data
	export let form // would be typed as null unless we do actions shenanigans

	const { user } = data
	const fee = (data.currentFee * data.asset.price).toFixed(2)
	const totalPrice = (1 + data.currentFee) * data.asset.price
	const itsFree = data.asset.price === 0 // IT'S FREEEEEEEEEEEEEE

	let regenerating = false

	const enhanceRegen: import("./$types").SubmitFunction = () => {
		regenerating = true
		return async ({ result }) => {
			if (result.type === "success") await invalidateAll()
			await applyAction(result)
			regenerating = false
		}
	}

	let replyingTo = writable("")
	const repliesCollapsed = writable({})
	const formData = superForm(data.form)
	export const snapshot = formData

	let refresh = 0
	let tabData = TabData(data.url, ["Recommended", "Comments"])

	const refreshReplies: import("@sveltejs/kit").SubmitFunction<any, any> =
		() =>
		async ({ result }) => {
			if (result.type === "success") await invalidateAll()
			refresh++
		}
</script>

<Head name={data.siteName} title={data.asset.name} />

<div class="ctnr max-w-240">
	<div class="flex <sm:flex-col">
		<div class="pr-4 pb-4">
			<img
				class:opacity-50={regenerating}
				class="image transition-opacity duration-300 aspect-1 w-80vw max-w-100"
				src={form?.icon ||
					`/avatarshop/${data.asset.id}/${data.slug}/icon`}
				alt={data.asset.name} />
		</div>
		<div class="w-full light-text">
			<div class="flex justify-between">
				<h1>{data.asset.name}</h1>
				<li class="dropdown pl-2 pt-2">
					<fa fa-ellipsis class="dropdown-ellipsis" />
					<div class="dropdown-content">
						<ul class="p-2 rounded-3">
							<button class="btn light-text pl-4 pr-0 text-start">
								<fa fa-pencil class="pr-2" />
								nothing here
							</button>
							<!-- <li class="rounded-2">
								<a
									class="btn light-text pl-4 pr-0 text-start"
									href="/requests">
									<fa fa-pencil class="pr-2" />
									Edit asset
								</a>
							</li> -->
							{#if user.permissionLevel >= 5 && [8, 11, 12].includes(data.asset.type)}
								<li class="rounded-2">
									<form
										use:enhance={enhanceRegen}
										method="POST"
										action="?/rerender">
										<button
											class="btn accent-text pl-4 pr-0 text-start">
											<fa fa-arrows-rotate class="pr-2" />
											<b>Rerender</b>
										</button>
									</form>
								</li>
							{/if}
						</ul>
					</div>
				</li>
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
								<tr>
									<td>Price</td>
									<td class="text-emerald-6">
										{data.currencySymbol}
										{data.asset.price}
									</td>
								</tr>
								<tr>
									<td>Fee</td>
									<td class="text-yellow-5">
										{data.currencySymbol}
										{fee}
									</td>
								</tr>
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

	<Tab {tabData} />

	<Tab {tabData}>
		<PostReply {formData} comment />
		{#key refresh}
			{#if data.asset.replies.length > 0}
				{#each data.asset.replies as reply, num}
					<ForumReply
						{user}
						{reply}
						{num}
						{replyingTo}
						postId={data.asset.id.toString()}
						assetSlug={data.slug}
						postAuthorName={data.asset.creator.username || ""}
						{repliesCollapsed}
						topLevel={false}
						pinnable
						{refreshReplies} />
				{/each}
			{:else}
				<h3 class="text-center pt-6">
					No replies yet. Be the first to post one!
				</h3>
			{/if}
		{/key}
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
