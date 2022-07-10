

<main>
	<nav class="navbar navbar-expand-lg navbar-dark" style="background: transparent; backdrop-filter: blur(6px)">
		<div class="container">
			<a class="navbar-brand" href="/">Mercury</a>
			<div class="d-flex">
				<a type="button" href="y" class="btn btn-secondary my-2 my-sm-0">Login</a>
			</div>
		</div>
	</nav>

	<slot />
</main>

<style lang="sass">
	main
		background: hsla(305, 63%, 80%, 1)

		background-image: linear-gradient(180deg, rgba(255, 255, 255, 0.01), rgba(255, 255, 255, 1) 85%), radial-gradient(ellipse at top left, rgba(13, 110, 253, 0.5), #0000 50%), radial-gradient(ellipse at top right, rgba(255, 228, 132, 0.5), #0000 50%), radial-gradient(ellipse at center right, rgba(112.520718, 44.062154, 249.437, 0.5), #0000 50%), radial-gradient(ellipse at center left, rgba(214, 51, 132, 0.5), #0000 50%)
		height: 100vh
</style>
