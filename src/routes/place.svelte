<script lang="ts">
	let place = {
		name: "[MEGA] Simulator simulator: SIMULATOR UPDATE! (New code)",
		img: "https://tr.rbxcdn.com/32f4b1e24aa4b914ad5f21539338a60b/150/150/Image/Png",
		desc: "In this game you can simulate simulators while facing extremely intense and interesting situations!",
		by: "Goodimo",
	}

	let joining = false

	function join() {
		joining = true
		setTimeout(() => {
			joining = false
		}, 8000)
	}
</script>

<svelte:head>
	<title>{place.name} - Renova</title>
</svelte:head>

<main>
	<div class="d-flex mt-12">
		<div class="flex flex-col me-3" id="thumbnail">
			<img src={place.img} alt={place.name} />
			<p class="dark-text mt-2">
				<b>By:</b> <a href="user?name={place.by}">{place.by}</a>
			</p>
		</div>
		<div class="flex flex-col">
			<h2 class="dark-text">{place.name}</h2>
			<button id="play" on:click={join}><img src="play.svg" alt="Play button icon" /></button>
			
		</div>
	</div>
	<h4 class="dark-text mt-4">Description</h4>
	<p class="dark-text">
		{place.desc}
	</p>
</main>

<style lang="sass">
	main
		width: 60rem
		margin: auto
	#thumbnail
		img
			border-radius: 0.75rem
	
	#play
		border: none
		width: 40%
		background: #24b170
		height: 4rem
		border-radius: 0.75rem
		padding: 0.75rem
		img
			height: 100%
</style>
