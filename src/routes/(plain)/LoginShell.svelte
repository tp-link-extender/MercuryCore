<script lang="ts">
	export let descriptions: string[][]
	export let pad = false
</script>

<div class="light-text flex <lg:flex-col min-h-screen h-full overflow-auto">
	<div
		id="dark"
		class="lg:w-1/2 p-8vw pt-5vh {pad ? 'lg:pt-20vh' : 'lg:pt-11vh'}">
		<a href="/" class="btn btn-lg border-0 px-0 text-base">
			<fa fa-arrow-left class="pr-2" />
			Home
		</a>
		<h1 class="font-bold pb-6 text-14">
			Mercury 2 <span class="opacity-50">rc</span>
		</h1>

		{#each descriptions as [title, description]}
			<div class="pl-4 w-full">
				<h2 class="font-semibold">{title}</h2>
				<p class="opacity-75">{description}</p>
			</div>
		{/each}
	</div>

	<div
		id="light"
		class="lg:w-1/2 py-8vh px-8vw pt-5vh {pad
			? 'lg:pt-20vh'
			: 'lg:pt-11vh'} z-1">
		<div class="max-w-120 mx-auto">
			<slot />
		</div>
	</div>
</div>

<style lang="stylus">
	#light
		background radial-gradient(#35332e7f 1px, #0000 1px), var(--background)
		background-size 2rem 2rem
		background-attachment fixed

		:global(form) :global(button)
			width 100%

	#dark
		background linear-gradient(-20deg, var(--darker) 50%, var(--mainaccent) 250%)
</style>
