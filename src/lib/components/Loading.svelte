<script lang="ts">
	const size = 80
	const duration = "0.7s"
	const unit = "px"
</script>

<div id="wrapper" class="rounded-circle" style="--size: {size}{unit}; --duration: {duration}; --rotation: {Math.random() * 360}deg;">
	<img src="/innerlogo.svg" alt="Mercury logo inner part (M)"/>
	<img src="/outerlogo.svg" alt="Mercury logo outer part (circle around M)" id="outer"/>
</div>

<style lang="sass">

	#wrapper
		height: var(--size)
		width: var(--size)
		animation: fade calc(var(--duration) * 0.9) 0s infinite linear
		position: relative
	
	#outer
		transform: rotate(var(--rotation))
		animation: moon var(--duration) 0s infinite linear

	img
		opacity: 0.5
		height: var(--size)
		width: var(--size)
		box-sizing: border-box
		position: absolute

	@keyframes moon
		100%
			transform: rotate(calc(var(--rotation) + 360deg))

	@keyframes fade
		0%
			opacity: 0.35
		50%
			opacity: 0.75
		100%
			opacity: 0.35
</style>
