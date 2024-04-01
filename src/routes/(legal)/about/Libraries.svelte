<div class="relative lg:(transform translate-x--10vw)">
	<div class="transform translate-x-7vw">
		<img
			id="l2"
			class="absolute w-5/6 lg:w-full"
			src="/about_assets/library2.png"
			alt="Screenshot of Graphictoria library usage" />
	</div>
	<div class="transform translate-y-15vh">
		<img
			id="l1"
			class="absolute w-5/6 lg:w-full"
			src="/about_assets/library1.png"
			alt="Screenshot of Graphictoria library usage" />
	</div>
</div>

<style lang="stylus">
	@keyframes bob
		0%
			transform translateY(0)
		50%
			transform translateY(10px)
		100%
			transform translateY(0)

	img
		border-radius 1rem
		border 5px solid var(--darker)
		box-shadow 4px 4px 15px black

		animation-timing-function ease-in-out

	#l1
		animation bob 4s infinite
	#l2
		animation bob 5.1s infinite
		animation-delay 2.4s
</style>
