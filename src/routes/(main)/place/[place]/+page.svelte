<script lang="ts">
	import { enhance } from "$app/forms"

	export let data: any

	const statistics = [
		["Activity", "2 visits"],
		["Creation", "19/01/2023"],
		["Updated", "Three hours ago"],
		["Genre", "Horror"],
		["Server Limit", "100"],
		["Currently Playing", "No one"],
	]
</script>

<svelte:head>
	<title>{data.name} - Mercury</title>
</svelte:head>

<div class="container">
	<div class="d-flex mt-12">
		<div class="flex flex-col me-3">
			<img id="thumbnail" src={data.image} alt={data.name} class="rounded-4 img-fluid" />
		</div>
		<div class="flex flex-col">
			<h2 class="light-text">{data.name}</h2>
			<p class="light-text mt-2">
				<b>By</b> <a href="/{data.owner.username}" class="text-decoration-none">{data.owner.displayname}</a>
			</p>
			<div id="buttons">
				<button id="join" class="btn btn-lg btn-success"><img src="/place/join.svg" alt="Join button icon" /></button>
				<div class="mt-2">
					<form class="align-self-center" method="POST" use:enhance>
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
	</div>
	<nav class="mt-4">
		<ul class="nav nav-pills nav-fill">
			<a class="nav-link mx-1 light-text mb-2" href="#description" role="tab">Description</a>
			<a class="nav-link mx-1 light-text mb-2" href="#statistics" role="tab">Statistics</a>
			<a class="nav-link mx-1 light-text mb-2" href="#description" role="tab">Description</a>
			<a class="nav-link mx-1 light-text mb-2" href="#statistics" role="tab">Statistics</a>
			<a class="nav-link mx-1 light-text mb-2" href="#description" role="tab">Description</a>
			<a class="nav-link mx-1 light-text mb-2" href="#statistics" role="tab">Statistics</a>
		</ul>
	</nav>
	<div class="tab-content">
		<div class="tab-pane content rounded-2 show active m-1 p-3" id="description">
			<p class="light-text">
				{data.description}
			</p>
		</div>
		<div class="tab-pane show active" id="statistics">
			<div id="stats" class="container">
				<div class="row">
					{#each statistics as [title, stat]}
						<div class="p-1 col-6 col-sm-4 col-lg-3">
							<div class="p-2 card h-100">
								<div class="light-text row">
									<span class="h6 text-start col">
										{title}
									</span>
									<span class="text-end col">
										{stat}
									</span>
								</div>
							</div>
						</div>
					{/each}
				</div>
			</div>
		</div>
	</div>
</div>

<style lang="sass">
	:target
		display: block !important
		
	.container
		max-width: 60rem

	#buttons
		margin-top: auto
		display: flex
		flex-direction: column

	.tab-pane
		display: none
	.content, .card
		background: var(--accent)
	.nav-link
		background: var(--accent1)

	#thumbnail
		aspect-ratio: 16 / 9

	#join img
		height: 2.5rem
		width: 16rem
</style>
