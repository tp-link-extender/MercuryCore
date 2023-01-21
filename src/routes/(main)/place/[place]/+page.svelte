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
			<img id="thumbnail" src={data.image} alt={data.name} class="rounded-4" />
			<p class="light-text mt-2">
				<b>By:</b> <a href="/{data.owner}">{data.owner}</a>
			</p>
		</div>
		<div class="flex flex-col">
			<h2 class="light-text">{data.name}</h2>
			<button id="join" class="btn btn-lg btn-success"><img src="/place/join.svg" alt="Join button icon" /></button>
			<div class="mt-2">
				<form class="align-self-center" method="POST" use:enhance>
					<button name="action" value={data.likes ? "unlike" : "like"} class="btn {data.likes ? 'btn-primary' : 'btn-success'}">
						{#if data.likes}
							Unlike
						{:else}
							Like
						{/if}
					</button>
					<span class="light-text mx-2">
						{data.likeCount} likes
					</span>
					<button name="action" value={data.dislikes ? "undislike" : "dislike"} class="btn {data.dislikes ? 'btn-primary' : 'btn-danger'}">
						{#if data.dislikes}
							Undislike
						{:else}
							Dislike
						{/if}
					</button>
					<span class="light-text mx-2">
						{data.dislikeCount} dislikes
					</span>
				</form>
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
	
	#join img
		height: 2.5rem
		width: 16rem
</style>
