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

	<slot />
</main>

<style lang="sass">

	main
		overflow-x: hidden
		background: #f3f4f6
		min-height: 100vh
	nav
		z-index: 1
		background: rgba(0, 0, 0, 0.2)
		width: 100vw
		backdrop-filter: blur(6px)
</style>
