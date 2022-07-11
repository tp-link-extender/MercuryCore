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
<main>
	<div>
		<slot />
	</div>
	<footer class="position-relative text-center">
		<h4>Mercury</h4>
		Powering Divinity<br />
		<br />
		© Mercury 2022 - All rights reserved, we are not affiliated with Roblox Corporation.<br />
		<br />
		Rules | About | Terms of Service | Privacy Policy | Statistics<br />
	</footer>
</main>

<style lang="sass">
	nav
		z-index: 9
		background: rgba(0, 0, 0, 0.1)
		width: 100vw
		backdrop-filter: blur(6px)

	main
		overflow-x: hidden
		background: #f3f4f6
		min-height: 100vh
		div
			min-height: 72vh
			margin-top: 8vh

	footer
		border: 1px solid #999
		background: #ddd
		height: 20vh
		width: 100vw
		padding: 1vh
		bottom: 0

</style>
