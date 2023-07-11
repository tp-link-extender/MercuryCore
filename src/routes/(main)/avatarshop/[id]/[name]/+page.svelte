<script lang="ts">
	import { page } from "$app/stores"
	import { superForm } from "sveltekit-superforms/client"

	let replyingTo = writable("")
	const repliesCollapsed = writable({})

	export let data
	const { user } = data
	const {
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
					<p class="light-text d-flex mt-2 mb-0">
						<b>by</b>
						<a
							href="/user/{data.creatorUser?.number}"
							class="user light-text text-decoration-none">
							<span class="pfp bg-darker rounded-circle ms-1">
								<img
									src="/api/avatar/{data.creatorUser
										?.username}"
									alt={data.creatorUser?.username}
									class="rounded-circle rounded-top-0" />
							</span>
							{data.creatorUser?.username}
						</a>
					</p>
					<p class="light-text mt-2 mb-0">
						<b>Type</b>
						{data.type}
					</p>
					<p class="light-text mt-2 mb-0">
						<b>{data.sold}</b>
						sold
						<span class="float-end">
							<Report
								user={data.creatorUser?.username || ""}
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

	.pfp, .pfp img
		width: 3.5rem
		height: 3.5rem

	.user
		.pfp, img
			width: 1.5rem
			height: 1.5rem
</style>
