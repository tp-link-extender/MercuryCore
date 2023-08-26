<script lang="ts">
	let clicked = false
</script>

<footer class="position-relative text-center">
	<br />
	<p class="grey-text mb-2">
		<a href="/" class="text-decoration-none accent-text me-1">Mercury</a>
		2022-{new Date().getFullYear()}
		<button
			on:mousedown={() => (clicked = !clicked)}
			class="heart border-0 p-0 grey-text cursor-pointer"
			class:clicked>
			<span class="grey-text">made with</span>
			<i class="fa fa-heart" />
		</button>
	</p>
	<a class="light-text" href="/about">About</a>
	<span class="text-muted">|</span>
	<a class="light-text" href="/terms">Terms of Service</a>
	<span class="text-muted">|</span>
	<a class="light-text" href="/privacy">Privacy Policy</a>
	<span class="text-muted">|</span>
	<a class="light-text" href="/statistics">Statistics</a>
	<br />
	<br />
</footer>

<noscript>
	<div id="nojs" class="fixed bottom-0 block vw-100">
		<p class="light-text text-center">
			Javascript is disabled. You may have a diminished experience while
			using Mercury.
		</p>
	</div>
</noscript>

<style lang="stylus">
	.heart
		background transparent
		i
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

	.heart:not(.clicked) i:hover
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
		i
			animation heart 2s
		i
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
