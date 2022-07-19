<script lang="ts">
	import "/src/bootstrap.sass"
	import "/src/global.sass"
</script>

<nav class="navbar navbar-expand-lg navbar-dark position-fixed">
	<div class="container">
		<a class="navbar-brand" href="/">Mercury</a>
		<div class="d-flex">
			<a type="button" href="/home" class="btn my-2 my-sm-0 dark-text">Home</a>
			<a type="button" href="/discover" class="btn my-2 my-sm-0 dark-text">Discover</a>
			<a type="button" href="/catalog" class="btn my-2 my-sm-0 dark-text">Catalog</a>
		</div>
		<div class="d-flex">
			<a type="button" href="/login" class="btn btn-success my-2 my-sm-0">Login</a>
		</div>
	</div>
</nav>

<div id="all">
	<div id="bg" class="position-fixed" />
	<main>
		<slot />
	</main>

	<footer class="position-relative text-center">
		<a class="dark-text h4" href="/">Mercury</a>
		<p class="info text-muted">
			Powering Divinity<br />
			<br />
			© Mercury 2022 - All rights reserved, we are not affiliated with Roblox Corporation.<br />
		</p>
		<a class="dark-text h5" href="/rules">Rules</a>
		<a class="dark-text h5" href="/about">About</a>
		<a class="dark-text h5" href="/terms">Terms of Service</a>
		<a class="dark-text h5" href="/privacy">Privacy Policy</a>
		<a class="dark-text h5" href="/statistics">Statistics</a>
	</footer>
	<noscript>
		<div id="nojs" class="position-fixed bottom-0 d-block">
			<p class="dark-text text-center">Javascript is disabled. You may have a diminished experience while using Mercury.</p>
		</div>
	</noscript>
</div>

<style lang="sass">
	nav
		z-index: 9
		width: 100vw
		max-height: 10vh
		backdrop-filter: blur(6px)
		a
			margin-right: 0.5rem

	#all
		overflow-x: hidden
		height: 100%
		main
			min-height: 65vh
			margin-top: 10vh
			margin-bottom: 5vh

	#bg
		background-color: var(--background)
		min-height: 100vh
		height: 100%
		width: 100%
		z-index: -1
		
	footer
		background: rgba(0, 0, 0, 0.15)
		height: 20vh
		width: 100vw
		padding: 1vh
		.info
			margin-bottom: 1.75rem

		a 
			margin: 0 0.5rem
			text-decoration: none
			&:hover
				text-decoration: underline

	#nojs
		width: 100vw
		background: rgba(0, 0, 0, 0.5)
		transform: translate(0px, 1rem)
</style>
