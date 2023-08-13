<script lang="ts">
	import { page } from "$app/stores"
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
			enhance,
			delayed,
			capture,
			restore,
		} = superForm(data.form, {
			taintedMessage: false,
		})

	export const snapshot = { capture, restore }

	let modal = writable(false),
		tabData = TabData(data.url, ["Recommended", "Comments"])

	const types: any = {
		2: "T-Shirt",
		11: "Shirt",
		12: "Pants",
		13: "Decal",
	}
</script>

<Head title={data.name} />

<div class="container">
	<div class="row">
		<div class="col">
			<img
				class="image me-3 mb-3"
				src="/avatarshop/{data.id}/{data.name}/icon"
				alt={data.name} />
		</div>
		<div class="col light-text">
			<h1 class="mb-0">{data.name}</h1>
			<strong>by:</strong>
			<a
				href="/user/{data.creatorUser?.number}"
				class="user light-text text-decoration-none">
				<span class="pfp bg-darker rounded-circle ms-1">
					<img
						src="/api/avatar/{data.creatorUser?.username}"
						alt={data.creatorUser?.username}
						class="rounded-circle rounded-top-0" />
				</span>
				{data.creatorUser?.username}
			</a>
			<p class="mt-2">
				{#if data.description[0]}
					{data.description[0].text}
				{:else}
					<em>No description available</em>
				{/if}
			</p>

			<hr />
			<div class="row mb-2">
				<div class="col-md-4">
					<p class="mb-2">
						<strong>Sold:</strong>
						{data.sold}
						<br />
					</p>
					<p>
						<strong>Type:</strong>
						{types[data.type]}
					</p>
				</div>
				<div class="col d-flex flex-row-reverse">
					<div class="card">
						<div class="card-body">
							<p class="light-text mb-1 text-center">
								Price: <span class="text-success">
									<i class="far fa-gem" />
									{data.price}
								</span>
							</p>
							<button class="btn btn-success">
								<strong class="h5">
									{data.price > 0 ? "Buy Now" : "Get"}
								</strong>
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- <span class="w-100">

			<button
				name="action"
				on:click={() => modal.set(true)}
				id="buy"
				value="buy"
				class="btn btn-sm rounded-3 w-100 float-left mb-4 {data.owned
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
					Funds will be deducted from your account immediately upon
					pressing the buy button.
				</p>
			{/if} -->
	<!-- {#if form?.msg}
					<p class="text-danger">{form.msg}</p>
				{/if} -->
	<!-- </span> -->

	<div class="bg-a">
		<TabNav bind:tabData justify />
	</div>

	<Tab {tabData}>

	</Tab>

	<Tab {tabData}>
		<form use:enhance class="p-1" method="POST" action="?/reply">
			<label for="content" class="form-label light-text mt-2">
				Post a Comment
			</label>
			<fieldset class="col-lg-7 d-flex">
				<textarea
					bind:value={$form.content}
					{...$constraints.content}
					class="form-control {$errors.content ? 'is-in' : ''}valid"
					name="content"
					placeholder="What are your thoughts?"
					rows="4" />
				<button class="btn btn-success ms-3 mt-auto">
					{#if $delayed}
						Working...
					{:else}
						Comment
					{/if}
				</button>
			</fieldset>
			<p
				class="mb-3"
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
				postAuthorName={data.creatorUser?.username || ""}
				{repliesCollapsed}
				topLevel />
		{/each}
	</Tab>
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

	#buy
		z-index 5
		&:hover ~ #notify
			opacity 1
			height 1.5rem
			transform none

	#notify
		pointer-events none

	.pfp
	.pfp img
		width 3.5rem
		height 3.5rem

	.user
		.pfp
		img
			width 1.5rem
			height 1.5rem
</style>
