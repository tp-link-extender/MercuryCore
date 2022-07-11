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
		<strong>Copyringt &lbrace;C] Mercur 20222.</strong><br />
		yeet<br />
		yeet<br />
		yeet<br />
		yeet<br />
		yeet<br />
		yeet<br />
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
			min-height: 80vh

	footer
		border: 1px solid #999
		background: #ddd
		width: 100vw
		padding: 1vh
		bottom: 0

</style>
