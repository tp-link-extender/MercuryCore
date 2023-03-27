<script lang="ts">
	import { enhance } from "$app/forms"
	import Report from "$lib/components/Report.svelte"
	import { getUser } from "@lucia-auth/sveltekit/client"

	const user = getUser()

	export let data
	export let form
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
					<h2 class="light-text">{data.name}</h2>
					<p class="light-text mt-2 mb-0">
						<b>By</b>
						<a
							href="/user/{data.creator.number}"
							class="text-decoration-none">
							{data.creator.username}
						</a>
					</p>
					<br />
					<p class="light-text mt-2 mb-0">
						{data.description}
						<span class="float-end">
							<Report
								user={data.creator.username}
								url="/avatarshop/item/{data.id}" />
						</span>
					</p>
				</div>
			</div>
			<form
				use:enhance
				class="align-self-center col px-0 mb-2"
				method="POST">
				<button
					name="action"
					id="buy"
					value="buy"
					class="btn btn-lg w-100 float-left {data.owned
						? 'btn-secondary disabled'
						: $user?.currency < data.price
						? 'btn-danger disabled'
						: 'btn-success'}">
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
						class="btn btn-sm w-100 float-right btn-danger">
						[debug] delete from inventory
					</button>
				{:else if data.price != 0}
					<p class="light-text" id="notify">
						Funds will be deducted from your account immediately
						upon pressing the buy button.
					</p>
				{/if}
				{#if form?.msg}
					<p class="text-danger">{form.msg}</p>
				{/if}
				<div class="row mb-2 mt-3">
					<div class="col d-flex justify-content-start">
						<button
							name="action"
							value={data.likes ? "unlike" : "like"}
							class="btn btn-sm {data.likes
								? 'btn-success'
								: 'btn-outline-success'}">
							{#if data.likes}
								<i class="fa fa-thumbs-up" />
							{:else}
								<i class="fa-regular fa-thumbs-up" />
							{/if}
						</button>
					</div>
					<div class="col d-flex justify-content-end">
						<button
							name="action"
							value={data.dislikes ? "undislike" : "dislike"}
							class="btn btn-sm {data.dislikes
								? 'btn-danger'
								: 'btn-outline-danger'}">
							{#if data.dislikes}
								<i class="fa fa-thumbs-down" />
							{:else}
								<i class="fa-regular fa-thumbs-down" />
							{/if}
						</button>
					</div>
				</div>
				<div class="progress rounded-pill" style="height: 3px">
					<div
						class="progress-bar bg-success"
						role="progressbar"
						aria-label="Likes"
						style="width: {(data.likeCount /
							(data.dislikeCount + data.likeCount || 1)) *
							100}%"
						aria-valuenow={data.likeCount}
						aria-valuemin={0}
						aria-valuemax={data.dislikeCount + data.likeCount} />
					<div
						class="progress-bar bg-danger"
						role="progressbar"
						aria-label="Dislikes"
						style="width: {(data.dislikeCount /
							(data.dislikeCount + data.likeCount || 1)) *
							100}%"
						aria-valuenow={data.dislikeCount}
						aria-valuemin={0}
						aria-valuemax={data.dislikeCount + data.likeCount} />
				</div>
				<div class="row">
					<div class="col d-flex justify-content-start">
						<span class="light-text mx-2">
							{data.likeCount} like{data.likeCount == 1
								? ""
								: "s"}
						</span>
					</div>
					<div class="col d-flex justify-content-end">
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
	<ul class="nav nav-pills nav-justified mb-3 bg-a" id="pills-tab">
		<li class="nav-item" role="presentation">
			<button
				class="nav-link active"
				id="pills-desc-tab"
				data-bs-toggle="pill"
				data-bs-target="#pills-desc"
				type="button"
				role="tab"
				aria-controls="pills-desc"
				aria-selected="true">
				Description
			</button>
		</li>
		<li class="nav-item" role="presentation">
			<button
				class="nav-link"
				id="pills-game-tab"
				data-bs-toggle="pill"
				data-bs-target="#pills-game"
				type="button"
				role="tab"
				aria-controls="pills-game"
				aria-selected="false">
				Owners
			</button>
		</li>
	</ul>
	<div class="tab-content" id="pills-tabContent">
		<div
			class="tab-pane fade show active"
			id="pills-desc"
			role="tabpanel"
			aria-labelledby="pills-desc-tab"
			tabindex={0}>
			<p class="light-text">{data.description}</p>
		</div>
		<div
			class="tab-pane fade"
			id="pills-game"
			role="tabpanel"
			aria-labelledby="pills-game-tab"
			tabindex={0}>
			<div class="row">
				{#each data.owners as owner}
					<a
						href="/user/{owner.number}"
						class="d-flex text-decoration-none py-2 col col-lg-3 col-md-4 col-sm-6">
						<div class="me-3 rounded-circle pfp bg-a">
							<img
								src={owner?.image}
								alt={owner.username}
								class="rounded-circle rounded-top-0" />
						</div>
						<p class="light-text my-auto h5 me-4 text-truncate">
							{owner.username}
						</p>
					</a>
				{/each}
			</div>
		</div>
	</div>
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

	.nav-link
		border-radius: 0
		color: var(--light-text)

		.active
			background: transparent
			border-style: solid
			border-width: 0px 0px 2px 0px
			border-color: var(--bs-blue)

	.pfp
		width: 3.5rem
		height: 3.5rem
		img
			width: 3.5rem
			height: 3.5rem
</style>
