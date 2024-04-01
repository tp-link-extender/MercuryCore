<script lang="ts">
	import Waves from "./Waves.svelte"
</script>

<div id="gradientbg" class="size-full fixed" />

<Waves />

<div id="main" class="absolute w-full top-36%">
	<div class="flex flex-col justify-center items-center relative">
		<h1 class="-f font-bold opacity-75 text-16 text-center">Mercury 2</h1>
		<p class="lead text-center">
			Endless possibilities. New features. Same nostalgia.
		</p>
		<div class="pb-2 text-center">
			<a
				type="button"
				href="/studio/login"
				class="inline btn btn-secondary">
				<b>Log in</b>
				<fa fa-right-to-bracket class="pl-1" />
			</a>
		</div>
	</div>
</div>

<style lang="stylus">
	#gradientbg
		background url(/fallbackgradient.png)
		background-size cover
</style>
