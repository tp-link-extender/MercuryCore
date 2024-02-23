<script lang="ts">
	export let descriptions: string[][]
</script>

<div class="light-text overflow-hidden h-full">
	<!-- todo fix the lg:h-9999 please -->
	<div
		id="dark"
		class="bg-darker lg:(h-9999 float-left w-1/2) px-8% pt-5 lg:pt-6%">
		<a type="button" href="/" class="btn btn-lg border-0 px-0 text-base">
			<fa fa-arrow-left class="pr-2" />
			Home
		</a>
		<h1 class="sf font-bold pb-6 text-14">
			Mercury 2 <span class="opacity-50">beta</span>
		</h1>

		{#each descriptions as [title, description]}
			<div class="pl-4 w-full">
				<h2 class="font-semibold">{title}</h2>
				<p class="opacity-75">{description}</p>
			</div>
		{/each}
	</div>

	<div id="light" class="lg:(h-9999 float-right w-1/2) px-8% pt-5 lg:pt-9%">
		<div class="max-w-120 mx-auto">
			<slot />
		</div>
	</div>
</div>

<style lang="stylus">
	@import "../vars"

	:global(body)
		@media (min-width: 1024px)
			overflow hidden

	#light
		background url(/fallbackdots.svg)
		:global(form) :global(button)
			width 100%
</style>
