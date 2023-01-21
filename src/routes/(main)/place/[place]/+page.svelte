<script lang="ts">
	import { enhance } from "$app/forms"

	export let data: any
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
				<b>By:</b> <a href="/{data.owner}" class="text-decoration-none">{data.owner}</a>
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
						<div class="progress" style="height: 2px;">
							<div
								class="progress-bar progress-bar-striped bg-success"
								role="progressbar"
								aria-label="Likes"
								style="width: {(data.likeCount / (data.dislikeCount + data.likeCount)) * 100}%"
								aria-valuenow={data.likeCount}
								aria-valuemin="0"
								aria-valuemax={data.dislikeCount + data.likeCount}
							/>
							<div
								class="progress-bar progress-bar-striped bg-danger"
								role="progressbar"
								aria-label="Dislikes"
								style="width: {(data.dislikeCount / (data.dislikeCount + data.likeCount)) * 100}%"
								aria-valuenow={data.dislikeCount}
								aria-valuemin="0"
								aria-valuemax={data.dislikeCount + data.likeCount}
							/>
						</div>
						<div class="row">
							<div class="col d-flex justify-content-start">
								<span class="light-text mx-2">
									{data.likeCount} likes
								</span>
							</div>
							<div class="col d-flex justify-content-end">
								<span class="light-text mx-2">
									{data.dislikeCount} dislikes
								</span>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	<h4 class="light-text mt-4">Description</h4>
	<p class="light-text">
		{data.description}
	</p>
</div>

<style lang="sass">
	.container
		width: 60rem

	#buttons
		margin-top: auto
		display: flex
		flex-direction: column
	
	#thumbnail
		aspect-ratio: 16 / 9

	#join img
		height: 2.5rem
		width: 16rem
</style>
