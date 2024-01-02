<script lang="ts">
	export let data: import("../../routes/$types").LayoutData

	let clicked = false
</script>

<footer class="relative text-center">
	<br />
	<div class="grey-text pb-2">
		<a href="/" class="no-underline accent-text pr-2">Mercury</a>
		2022-{new Date().getFullYear()}
		<button
			on:mousedown={() => (clicked = !clicked)}
			id="heart"
			class="border-0 p-0 pl-1 pr-2 grey-text cursor-pointer text-base
			bg-transparent"
			class:clicked>
			<span class="grey-text">made with</span>
			<fa fa-heart />
		</button>
		{data.lines} lines of code
	</div>
	<a class="light-text" href="/about">About</a>
	<span class="opacity-25">|</span>
	<a class="light-text" href="/terms">Terms of Service</a>
	<span class="opacity-25">|</span>
	<a class="light-text" href="/privacy">Privacy Policy</a>
	<span class="opacity-25">|</span>
	<a class="light-text" href="/statistics">Statistics</a>
	<br />
	<br />
</footer>

<noscript>
	<div id="nojs" class="fixed bottom-0 block w-screen">
		<p class="light-text text-center">
			Javascript is disabled. You may have a diminished experience while
			using Mercury.
		</p>
	</div>
</noscript>

<style lang="stylus">
	#heart
		fa
			transition 0.2s
		span
			transition all 0.3s
			display inline-block
			overflow hidden
			white-space nowrap
			width 0
			vertical-align middle // not perfectly centered
			margin-top -0.2rem // there we go

		&:hover
			span
				width 4.6rem
				margin-left 0.2rem

	#heart:not(.clicked) fa:hover
		color var(--light-text) !important

	@keyframes heart
		0%
			transform scale(1)
		15%
			transform scale(0.9)
			rotate -10deg
		25%
			transform scale(1)
			rotate 5deg
		40%
			transform scale(1.2)
			filter drop-shadow(0 0 3px #f4b)
		100%
			transform scale(1)
			rotate 0

	.clicked
		fa
			animation heart 2s
		fa
		span
			color #f4b !important

	footer
		flex-shrink 0
		padding 1vh
		+-lg()
			padding-bottom 5rem
		a
			text-decoration none
			&:hover
				text-decoration underline

	#nojs
		background rgba(0, 0, 0, 0.5)
		transform translate(0px, 1rem)
</style>
