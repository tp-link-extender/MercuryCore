<div class="relative">
	<div>
		<img
			id="s1"
			class="absolute w-5/6 lg:w-full"
			src="/about_assets/screenshot1.png"
			alt="Screenshot of Mercury games page" />
	</div>
	<div class="transform translate-x-7vw translate-y-16vh">
		<img
			id="s2"
			class="absolute w-5/6 lg:w-full"
			src="/about_assets/screenshot2.png"
			alt="Screenshot of Mercury catalog page" />
	</div>
	<div class="transform translate-x-14vw translate-y--16vh">
		<img
			id="s3"
			class="absolute w-5/6 lg:w-full"
			src="/about_assets/screenshot3.png"
			alt="Screenshot of Mercury profile page" />
	</div>
</div>

<style lang="stylus">
	@keyframes bob
		0%
			transform translateY(0)
		50%
			transform translateY(-20px)
		100%
			transform translateY(0)

	img
		border-radius 1rem
		border 5px solid var(--darker)
		box-shadow -4px 4px 15px black

		animation-timing-function ease-in-out

	#s1
		animation bob 6s infinite
	#s2
		animation bob 7.1s infinite
		animation-delay 2.4s
	#s3
		animation bob 6.6s infinite
		animation-delay 1.8s
</style>
