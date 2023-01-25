<script lang="ts">
	import { enhance } from "$app/forms"
	import { getUser } from "@lucia-auth/sveltekit/client"

	export let data: any

	const statistics = [
		["Activity", "8 visits"],
		["Creation", "19/01/2023"],
		["Updated", "Three hours ago"],
		["Genre", "Horror"],
		["Server Limit", "100"],
		["Now Playing", "6 players"],
	]

	const images = ["/place/placeholderImage1.png", "/place/placeholderImage2.png"]

	const user = getUser()
</script>

<svelte:head>
	<title>{data.name} - Mercury</title>
</svelte:head>

<div class="container">
	<div class="row">
		<div id="carousel" class="carousel slide col-md-8 mb-3">
			<div class="carousel-indicators">
				{#each images as _, i}
					<button type="button" data-bs-target="#carousel" data-bs-slide-to={i} aria-label="Slide {i + 1}" class={!i ? "active" : ""} aria-current={!i} />
				{/each}
			</div>
			<div class="carousel-inner rounded-4">
				<div class="carousel-item active">
					<img src="/place/placeholderImage1.png" class="d-block w-100" alt="..." />
				</div>
				<div class="carousel-item">
					<img src="/place/placeholderImage2.png" class="d-block w-100" alt="..." />
				</div>
			</div>
			<button class="carousel-control-prev" type="button" data-bs-target="#carousel" data-bs-slide="prev">
				<span class="carousel-control-prev-icon" aria-hidden="true" />
				<span class="visually-hidden">Previous</span>
			</button>
			<button class="carousel-control-next" type="button" data-bs-target="#carousel" data-bs-slide="next">
				<span class="carousel-control-next-icon" aria-hidden="true" />
				<span class="visually-hidden">Next</span>
			</button>
		</div>
		<div class="flex col-md-4">
			<h2 class="light-text">{data.name}</h2>
			<p class="light-text mt-2">
				<b>By</b> <a href="/{data.owner.username}" class="text-decoration-none">{data.owner.displayname}</a>
			</p>
			<div id="buttons" class="row">
				<button id="join" class="btn btn-lg btn-success col"><img src="/place/join.svg" alt="Join button icon" /></button>
					<form class="align-self-center col mt-3" method="POST" use:enhance>
						<div class="row mb-2">
							<div class="col d-flex justify-content-start">
								<button name="action" value={data.likes ? "unlike" : "like"} class="btn btn-sm {data.likes ? 'btn-success' : 'btn-outline-success'}">
									{#if data.likes}
										<i class="fa-solid fa-thumbs-up" />
									{:else}
										<i class="fa-regular fa-thumbs-up" />
									{/if}
								</button>
							</div>
							<div class="col d-flex justify-content-end">
								<button name="action" value={data.dislikes ? "undislike" : "dislike"} class="btn btn-sm {data.dislikes ? 'btn-danger' : 'btn-outline-danger'}">
									{#if data.dislikes}
										<i class="fa-solid fa-thumbs-down" />
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
								style="width: {(data.likeCount / (data.dislikeCount + data.likeCount || 1)) * 100}%"
								aria-valuenow={data.likeCount}
								aria-valuemin={0}
								aria-valuemax={data.dislikeCount + data.likeCount}
							/>
							<div
								class="progress-bar bg-danger"
								role="progressbar"
								aria-label="Dislikes"
								style="width: {(data.dislikeCount / (data.dislikeCount + data.likeCount || 1)) * 100}%"
								aria-valuenow={data.dislikeCount}
								aria-valuemin={0}
								aria-valuemax={data.dislikeCount + data.likeCount}
							/>
						</div>
						<div class="row">
							<div class="col d-flex justify-content-start">
								<span class="light-text mx-2">
									{data.likeCount} like{data.likeCount == 1 ? "" : "s"}
								</span>
							</div>
							<div class="col d-flex justify-content-end">
								<span class="light-text mx-2">
									{data.dislikeCount} dislike{data.dislikeCount == 1 ? "" : "s"}
								</span>
							</div>
						</div>
					</form>
			</div>
		</div>
	</div>
	<ul class="nav nav-pills nav-justified mb-3" id="pills-tab" role="tablist">
		<li class="nav-item" role="presentation">
			<button class="nav-link active" id="pills-desc-tab" data-bs-toggle="pill" data-bs-target="#pills-desc" type="button" role="tab" aria-controls="pills-desc" aria-selected="true"
				>Description</button
			>
		</li>
		<li class="nav-item" role="presentation">
			<button class="nav-link" id="pills-game-tab" data-bs-toggle="pill" data-bs-target="#pills-game" type="button" role="tab" aria-controls="pills-game" aria-selected="false">Game</button>
		</li>
	</ul>
	<div class="tab-content" id="pills-tabContent">
		<div class="tab-pane fade show active" id="pills-desc" role="tabpanel" aria-labelledby="pills-desc-tab" tabindex="0">
			<p class="light-text">
				{data.description}
			</p>
		</div>
		<div class="tab-pane fade" id="pills-game" role="tabpanel" aria-labelledby="pills-game-tab" tabindex="0">
			<h4 class="light-text">Server List</h4>
			<div class="card mb-2">
				<div class="card-body">
					<div class="row">
						<div class="col col-2">
							<p class="light-text mb-2">Currently Playing: 6/20</p>
							<button id="join" class="btn btn-sm btn-success">Join Server</button>
						</div>
						<div class="col">
							<img src={$user?.image} id="pfp" alt="You" height="75" width="75" class="rounded-circle img-fluid rounded-top-0 ml-2" />
							<img src={$user?.image} id="pfp" alt="You" height="75" width="75" class="rounded-circle img-fluid rounded-top-0 ml-2" />
							<img src={$user?.image} id="pfp" alt="You" height="75" width="75" class="rounded-circle img-fluid rounded-top-0 ml-2" />
							<img src={$user?.image} id="pfp" alt="You" height="75" width="75" class="rounded-circle img-fluid rounded-top-0 ml-2" />
							<img src={$user?.image} id="pfp" alt="You" height="75" width="75" class="rounded-circle img-fluid rounded-top-0 ml-2" />
							<img src={$user?.image} id="pfp" alt="You" height="75" width="75" class="rounded-circle img-fluid rounded-top-0 ml-2" />
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<hr />
	<div class="row">
		{#each statistics as [title, stat]}
			<div class="col">
				<p class="light-text text-center"><b>{title}</b></p>
				<p class="light-text text-center">{stat}</p>
			</div>
		{/each}
	</div>
	<hr />
</div>

<style lang="sass">
	:target
		display: block !important
		
	@media only screen and (min-width: 576px)
		.container
			width: 60rem

	#buttons
		margin: auto
		display: flex
		flex-direction: column

	.card
		background: var(--accent)

	.nav-link
		border-radius: 0
		color: var(--light-text)

	.nav-pills
		background: var(--accent)

	.nav-pills .active
		background: transparent
		border-style: solid
		border-width: 0px 0px 2px 0px
		border-color: var(--bs-blue)

	#pfp
		background: var(--accent2)

	#join img
		height: 2.5rem
		width: 50%
</style>
