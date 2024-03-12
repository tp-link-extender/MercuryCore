<script lang="ts">
	import { applyAction } from "$app/forms"
	import { invalidateAll } from "$app/navigation"
	import { superForm } from "sveltekit-superforms/client"

	export let data
	const { user } = data
	export let form

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

	let refreshComments = 0

	let tabData = TabData(data.url, ["Recommended", "Comments"])

	const types: { [k: number]: string } = {
		1: "Image",
		2: "T-Shirt",
		11: "Shirt",
		12: "Pants",
		13: "Decal",
		18: "Face"
	}
</script>

<Head title={data.name} />

<div class="ctnr max-w-240">
	<div class="flex <sm:flex-col">
		<div class="pr-4 pb-4">
			<img
				class:opacity-50={regenerating}
				class="image transition-opacity duration-300 aspect-1 w-80vw max-w-100"
				src={form?.icon || `/avatarshop/${data.id}/${data.name}/icon`}
				alt={data.name} />
		</div>
		<div class="w-full light-text">
			<div class="flex justify-between">
				<h1>{data.name}</h1>
				<li class="dropdown dropdown-hover dropdown-end pl-2 pt-2">
					<fa fa-ellipsis />
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
							{#if data.user.permissionLevel >= 5 && [11, 12].includes(data.type)}
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

				{#if data.creator}
					<User
						user={data.creator}
						size="1.5rem"
						full
						thin
						bg="accent" />
				{/if}
			</div>
			<p class="mt-2">
				{#if data.description}
					{data.description.text}
				{:else}
					<em>No description available</em>
				{/if}
			</p>

			<hr />
			<div class="flex flex-wrap mb-2">
				<div class="w-full md:w-1/3">
					<p class="mb-2">
						<strong>{data.sold}</strong>
						sold
					</p>
					<p>
						<strong>Type</strong>
						{types[data.type]}
					</p>
				</div>
				<div class="w-full md:w-2/3 flex flex-row-reverse">
					<div class="card p-4">
						<p class="light-text text-center mb-0 pb-1">
							Price: <span class="text-emerald-6">
								<far fa-gem />
								{data.price}
							</span>
						</p>
						{#if !data.owned}
							<label for="buy" class="btn btn-success">
								<strong class="text-xl">
									{data.price > 0 ? "Buy Now" : "Get"}
								</strong>
							</label>
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
		{#if data.replies.length > 0}
			{#key refreshComments}
				{#each data.replies as reply, num}
					<ForumReply
						{user}
						{reply}
						{num}
						{replyingTo}
						postId={data.id.toString()}
						assetName={data.name}
						postAuthorName={data.creator.username || ""}
						{repliesCollapsed}
						topLevel={false}
						pinnable
						refreshReplies={() => refreshComments++} />
				{/each}
			{/key}
		{:else}
			<h3 class="text-center pt-6">
				No replies yet. Be the first to post one!
			</h3>
		{/if}
	</Tab>
</div>

<input type="checkbox" id="buy" class="modal-toggle" />
<div class="modal2">
	<div class="modal-box">
		{#if data.user.currency >= data.price}
			<h3 class="text-lg font-bold">Purchase {data.name}</h3>
			<p class="pb-4">
				Would you like to {data.price > 0 ? "buy" : "get"}
				{data.name} for
				{#if data.price > 0}
					<far fa-gem />
					{data.price}
				{:else}
					<strong>FREE</strong>
				{/if}
				?
			</p>

			<form method="POST" action="?/buy" class="inline">
				<button class="btn btn-success">
					{data.price > 0 ? "Buy Now" : "Get"}
				</button>
			</form>
			<label for="buy" class="btn btn-dark ml-2">{data.noText}</label>
		{:else}
			<h3 class="text-lg font-bold">Insufficient funds</h3>
			<span>
				You don't have enough <fa fa-gem />
				s to buy this item.
			</span>
			<p>
				You'll need <strong>
					{data.price - data.user.currency}
				</strong>
				more.
			</p>

			<label for="buy" class="btn btn-danger">{data.failText}</label>
		{/if}
	</div>
	<label class="modal-backdrop" for="buy">Close</label>
</div>

<style lang="stylus">
	.image
		background var(--accent1)
		background-image:
			linear-gradient(45deg,
				var(--darker) 25%, transparent 25%,
				transparent 75%, var(--darker) 75%
			),
			linear-gradient(45deg,
				var(--darker) 25%, transparent 25%,
				transparent 75%, var(--darker) 75%
			)
		background-size 20px 20px
		background-position 0 0, 10px 10px

	#buy
		z-index 5

	.modal-box
		min-width 30rem
</style>
