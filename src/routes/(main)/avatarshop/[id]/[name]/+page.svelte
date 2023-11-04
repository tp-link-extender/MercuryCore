<script lang="ts">
	import { page } from "$app/stores"
	import { enhance } from "$app/forms" // idky
	import { superForm } from "sveltekit-superforms/client"

	export let data

	let replyingTo = writable("")
	const repliesCollapsed = writable({}),
		{ user } = data,
		{
			form,
			errors,
			message,
			constraints,
			enhance: enhance2,
			delayed,
			capture,
			restore,
		} = superForm(data.form, {
			taintedMessage: false,
		})

	export const snapshot = { capture, restore }

	let tabData = TabData(data.url, ["Recommended", "Comments"])

	const types: { [k: number]: string } = {
		1: "Image",
		2: "T-Shirt",
		11: "Shirt",
		12: "Pants",
		13: "Decal",
		18: "Face",
	}

	const usernav = [["fa-pencil", "Edit Asset", "/requests"]]
</script>

<Head title={data.name} />

<div class="container">
	<div class="row">
		<div class="col pe-4 pb-4">
			<img
				class="image"
				src="/avatarshop/{data.id}/{data.name}/icon"
				alt={data.name} />
		</div>
		<div class="col light-text">
			<div class="row">
				<div class="col">
					<h1 class="mb-0">{data.name}</h1>
				</div>
				<div class="col d-flex justify-content-end">
					<li class="dropdown dropdown-hover dropdown-end ps-2 pt-2">
						<fa fa-ellipsis />
						<div class="dropdown-content">
							<ul class="p-2 rounded-3">
								{#each usernav as [icon, title, href]}
									<li class="rounded-2">
										<a
											class="btn light-text ps-4 pe-0 text-start"
											{href}>
											<fa class="{icon} me-2" />
											{title}
										</a>
									</li>
								{/each}
								{#if data.user.permissionLevel > 2}
									<li class="rounded-2">
										<form
											use:enhance
											method="POST"
											action="?/rerender">
											<button
												class="btn text-primary ps-4 pe-0 text-start">
												<i
													class="fa fa-arrows-rotate me-2" />
												<b>Re-render</b>
											</button>
										</form>
									</li>
								{/if}
							</ul>
						</div>
					</li>
				</div>
			</div>
			<div class="d-flex">
				<strong class="pe-2">by:</strong>

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
			<div class="row mb-2">
				<div class="col-md-4">
					<p class="mb-2">
						<strong>{data.sold}</strong>
						sold
					</p>
					<p>
						<strong>Type</strong>
						{types[data.type]}
					</p>
				</div>
				<div class="col d-flex flex-row-reverse">
					<div class="card">
						<div class="card-body">
							<p class="light-text text-center mb-0">
								Price: <span class="text-success">
									<far fa-gem />
									{data.price}
								</span>
							</p>
							{#if !data.owned}
								<label for="buy" class="btn btn-success mt-1">
									<strong class="fs-3">
										{data.price > 0 ? "Buy Now" : "Get"}
									</strong>
								</label>
							{:else}
								<span class="btn btn-secondary mt-1 disabled">
									<strong class="fs-3">Owned</strong>
								</span>
							{/if}
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<TabNav bind:tabData justify />

	<Tab {tabData} />

	<Tab {tabData}>
		<form use:enhance2 class="py-2" method="POST" action="?/reply">
			<label for="content" class="light-text py-2">Post a Comment</label>
			<fieldset class="col-lg-7 d-flex">
				<textarea
					bind:value={$form.content}
					{...$constraints.content}
					class="form-control {$errors.content ? 'is-in' : ''}valid"
					name="content"
					placeholder="What are your thoughts?"
					rows="4" />
				<button class="btn btn-success ms-4 mt-auto">
					{#if $delayed}
						Working...
					{:else}
						Comment
					{/if}
				</button>
			</fieldset>
			<p
				class="mb-4"
				class:text-success={$page.status == 200}
				class:text-danger={$page.status >= 400}>
				{$message || ""}
			</p>
		</form>

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
				topLevel />
		{/each}
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

			<form method="POST" action="?/buy&a=buy" class="d-inline">
				<button class="btn btn-success">
					{data.price > 0 ? "Buy Now" : "Get"}
				</button>
			</form>
			<label for="buy" class="btn btn-dark ms-2">{data.noText}</label>
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
	containerMinWidth(60rem)

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

		height 25rem
		width 25rem

		+-sm()
			height 15rem
			width 15rem

	#notify
		font-size 0.8rem
		opacity 0
		height 0
		transform translateY(-1.5rem)
		transition all 0.2s ease-out
		pointer-events none

	#buy
		z-index 5

	.modal-box
		min-width 30rem
</style>
