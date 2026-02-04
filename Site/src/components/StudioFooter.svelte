<script lang="ts">
	const {
		data
	}: {
		data: import("../routes/$types").LayoutData
	} = $props()

	let clicked = $state(false)
</script>

<footer class="bg-darker relative flex justify-center <lg:pb-20!">
	<div
		class="flex <sm:flex-col justify-between items-start w-200 p-4 sm:pb-8">
		<div>
			<img
				src="/assets/icon"
				alt="{data.siteName} logo"
				class="size-8 opacity-50" />
			<a href="/" class="no-underline pl-2">{data.siteName}</a>
			{#if data.tagline}
				<span class="grey-text pl-1">&ndash;</span>
				<span class="grey-text pl-1">
					{data.tagline}
				</span>
			{/if}
		</div>
		<div class="sm:text-right <sm:pt-4">
			<div class="flex <sm:flex-col sm:gap-3 justify-end pb-2">
				{#if data.user && data.pages.includes("Statistics")}
					<a class="light-text" href="/statistics">Statistics</a>
				{/if}
			</div>
		</div>
	</div>
</footer>

<style>
	footer {
		flex-shrink: 0;
		padding: 1vh;
	}
	footer a {
		text-decoration: none;
	}
	footer a:hover {
		text-decoration: underline;
	}
</style>
