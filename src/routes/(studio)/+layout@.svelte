<main>
	<slot />

	<footer>
		<p><a href="/">Mercury</a> 2022-{new Date().getFullYear()}</p>
		<a class="footer" href="/about">About</a>
		|
		<a class="footer" href="/terms">Terms of Service</a>
		|
		<a class="footer" href="/privacy">Privacy Policy</a>
		|
		<a class="footer" href="/statistics">Statistics</a>
	</footer>
</main>

<style lang="sass">
	@use "./vars.sass"

	main
		z-index: 1

	:root
		background-color: vars.$background
		color: vars.$light-text
		font-family: SFUIBold

	footer
		text-align: center

	a
		color: vars.$grey-text
		text-decoration: none
		transition: all 1s ease-in-out
		margin: 0 3px
		&:hover
			color: vars.$accent3
</style>
