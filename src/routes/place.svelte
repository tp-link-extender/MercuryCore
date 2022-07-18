<script lang="ts">
	import { page } from "$app/stores"

	const name = $page.url.searchParams.get("name")
	const by = $page.url.searchParams.get("by")

	const place = {
		img: "https://tr.rbxcdn.com/32f4b1e24aa4b914ad5f21539338a60b/150/150/Image/Png",
		desc: "In this game you can simulate simulators while facing extremely intense and interesting situations!",
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
	<title>{name} - Mercury</title>
</svelte:head>

<main class="container">
	<div class="d-flex mt-12">
		<div class="flex flex-col me-3" id="thumbnail">
			<img src={place.img} alt={name} />
			<p class="dark-text mt-2">
				<b>By:</b> <a href="/user?name={by}">{by}</a>
			</p>
		</div>
		<div class="flex flex-col">
			<h2 class="dark-text">{name}</h2>
			<button id="join" class="bg-success" on:click={join}><img src="join.svg" alt="Join button icon" /></button>
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

	#thumbnail
		img
			border-radius: 0.75rem
	
	#join
		border: none
		width: 18rem
		height: 4rem
		border-radius: 0.75rem
		padding: 0.75rem
		img
			height: 100%
</style>
