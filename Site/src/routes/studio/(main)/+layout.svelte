<script lang="ts">
	import StudioFooter from "$components/StudioFooter.svelte"

	const { data } = $props()
</script>

<main>
	<!-- <slot /> -->
	<div class="mx-auto">
		<h1 class="pt-16">Hey, {data.user.username}</h1>
		<p>What will you build today?</p>
	</div>
	<div class="mx-auto pt-8">
		<h1 class="text-center">Your places</h1>
		<b><a href="/templates" class="text-center">Create a new game +</a></b>
	</div>
	<div class="mx-auto mt-8 pb-16">
		<div id="all">
			{#each Array(3) as _}
				<a href="/place" class="game-link">
					<img src="/place/test.jpg" alt="place" />
					<div class="text">
						<p>le game</p>
					</div>
				</a>
			{/each}
		</div>
	</div>
</main>

<StudioFooter {data} />

<style>
	.game-link {
		text-align: center;
		text-decoration: none;
		overflow: hidden;
		margin: none;
		width: 10rem;
		display: inline-block;
		margin: 0.5rem;
		color: light-text;
	}

	a {
		display: block;
		text-decoration: none;
	}

	fa {
		font-family: faSolid;
		color: grey-text;
		line-height: 1;
	}

	.text {
		background-color: darker;
		padding: 0.7rem;
		margin-top: -0.5rem;
		padding-bottom: 1.8rem;
	}

	p {
		margin: 0;
		margin-bottom: 0.5rem;
	}

	img {
		width: 10rem;
		height: 10rem;
	}

	#all {
		width: fit-content;
		text-align: center;
	}
</style>
