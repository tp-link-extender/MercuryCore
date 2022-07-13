<script lang="ts">
	import "./bootstrap.sass"
</script>

<nav class="navbar navbar-expand-lg navbar-dark position-fixed">
	<div class="container">
		<a class="navbar-brand" href="/">Mercury</a>
		<div class="d-flex">
			<a type="button" href="login" class="btn btn-secondary my-2 my-sm-0">Login</a>
		</div>
	</div>
</nav>

<div id="bg" class="position-absolute" />
<main>
	<div id="content">
		<slot />
	</div>

	<footer class="position-relative text-center">
		<a class="text-dark h4" href="/">Mercury</a>
		<p class="info text-muted">
			Powering Divinity<br />
			<br />
			© Mercury 2022 - All rights reserved, we are not affiliated with Roblox Corporation.<br />
		</p>
		<a class="text-dark h5" href="/rules">Rules</a>
		<a class="text-dark h5" href="/about">About</a>
		<a class="text-dark h5" href="/terms">Terms of Service</a>
		<a class="text-dark h5" href="/privacy">Privacy Policy</a>
		<a class="text-dark h5" href="/statistics">Statistics</a>
	</footer>
</main>

<style lang="sass">
	nav
		z-index: 9
		background: rgba(0, 0, 0, 0.15)
		width: 100vw
		backdrop-filter: blur(6px)

	main
		overflow-x: hidden
		min-height: auto
		height: 100%
		#content
			min-height: 72vh
			margin-top: 8vh

	#bg
		background-color: #f3f4f6
		height: 100%
		width: 100%
		z-index: -5
		

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

</style>
