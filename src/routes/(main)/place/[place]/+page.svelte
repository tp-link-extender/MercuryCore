<script lang="ts">
	export let data: any

	let joining = false

	function join() {
		joining = true
		setTimeout(() => {
			joining = false
		}, 8000)
	}
</script>

<svelte:head>
	<title>{data.name} - Mercury</title>
</svelte:head>

<div class="container">
	<div class="d-flex mt-12">
		<div class="flex flex-col me-3" id="thumbnail">
			<img src={data.image} alt={data.name} />
			<p class="light-text mt-2">
				<b>By:</b> <a href="/{data.owner}">{data.owner}</a>
			</p>
		</div>
		<div class="flex flex-col">
			<h2 class="light-text">{data.name}</h2>
			<button id="join" class="btn btn-lg btn-success" on:click={join}><img src="/join.svg" alt="Join button icon" /></button>
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

	#thumbnail
		img
			border-radius: 0.75rem
	
	#join img
		height: 2.5rem
		width: 16rem
</style>
