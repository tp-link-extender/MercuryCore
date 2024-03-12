<script lang="ts">
	export let data: import("../../../routes/studio/$types").LayoutData
</script>

<footer class="bg-darker w-full">
	<div
		class="mx-auto flex <md:flex-col justify-between items-start w-200 p-4 pb-8">
		<div>
			<img src="/icon-footer.svg" alt="Mercury logo" class="size-8" />
			<a href="/studio" class="no-underline pl-2">Mercury</a>
			<span class="grey-text pl-1">
				2021-{new Date().getFullYear()}
			</span>
		</div>
		<div class="md:text-right <md:pt-4">
			<div class="grey-text pb-2">
				<span class="grey-text pr-1">
					<!-- Brag -->
					{data.lines} lines of code
				</span>
				&ndash;
				<span
					id="heart"
					class="grey-text border-0 pl-1 pr-2 text-base bg-transparent">
					made with
					<fa fa-heart class="pl-1" />
				</span>
			</div>
			<div>
				<a class="light-text pr-3" href="/studio/about">About</a>
				<a class="light-text pr-3" href="/studio/terms">
					Terms of Service
				</a>
				<a class="light-text pr-3" href="/studio/privacy">
					Privacy Policy
				</a>
				<a class="light-text" href="/studio/statistics">Statistics</a>
			</div>
		</div>
	</div>
</footer>

<style lang="stylus">
	footer
		flex-shrink 0
		padding 1vh
		+-lg()
			padding-bottom 5rem
		a
			text-decoration none
			&:hover
				text-decoration underline
</style>
