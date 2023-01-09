<script lang="ts">
	import { getUser } from "@lucia-auth/sveltekit/client"
	export let data: any
	const user = getUser()

	// explicitly any to prevent warnings
	const statusColours: any = {
		Online: "bg-info",
		Joined: "bg-success",
		Developing: "bg-warning",
	}
</script>

<svelte:head>
	<title>Home - Mercury</title>
</svelte:head>

<div class="container">
	<div class="mt-5">
		<div class="row m-0 p-0">
			{#each data.places as place}
				<a class="place mb-3 rounded-3 col col-4 col-sm-3 col-md-2 text-center light-text px-2" href="/{place.ownerUsername}/{place.name}">
					<img src={place.image} class="mb-2 w-100 rounded-3" alt={place.name} />
					{place.name}
				</a>
			{/each}
		</div>
	</div>
	<br /><br />
</div>

<style lang="sass">
	.container
		max-width: 60rem
		font-size: 0.9rem
					
	.place
		text-decoration: none
		img
			background: black

	.place img
		border-radius: 0.5rem
</style>
