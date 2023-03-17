<footer class="position-relative text-center">
	<br />
	<p class="grey-text mb-2">
		© <a href="/" class="text-decoration-none">Mercury</a>
		2022-{new Date().getFullYear()}
		<br />
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
	<div id="nojs" class="position-fixed bottom-0 d-block vw-100">
		<p class="light-text text-center">
			Javascript is disabled. You may have a diminished experience while
			using Mercury.
		</p>
	</div>
</noscript>

<style lang="sass">
	footer
		flex-shrink: 0
		padding: 1vh
		a 
			text-decoration: none
			&:hover
				text-decoration: underline

	#nojs
		background: rgba(0, 0, 0, 0.5)
		transform: translate(0px, 1rem)
</style>
