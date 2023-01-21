<script lang="ts">
	const duration = "0.6s"
	const size = 60
	const unit = "px"
	const moonSize = size / 7
	const top = size / 2 - moonSize / 2
</script>

<div id="wrapper" class="rounded-circle" style="--size: {size}{unit}; --moonSize: {top}px; --duration: {duration}; --rotation: {Math.random() * 360}deg;">
	<div id="circle-one" class="rounded-circle"/>
	<div id="circle-two" class="rounded-circle"/>
</div>

<style lang="sass">

	#wrapper
		height: var(--size)
		width: var(--size)
		transform: rotate(var(--rotation))
		animation: moon var(--duration) 0s infinite linear
		animation-fill-mode: forwards
		position: relative

	#circle-one
		top: var(--moonSize)
		background-color: var(--mainaccent)
		width: calc(var(--size) / 6)
		height: calc(var(--size) / 6)
		animation-fill-mode: forwards
		opacity: 0.8
		position: absolute

	#circle-two
		opacity: 0.1
		border: calc(var(--size) / 6) solid var(--mainaccent)
		height: var(--size)
		width: var(--size)
		animation: fade calc(var(--duration) * 1.8) 0s infinite linear
		box-sizing: border-box

	@keyframes moon
		100%
			transform: rotate(calc(var(--rotation) + 360deg))

	@keyframes fade
		0%
			opacity: 0.05
		50%
			opacity: 0.25
		100%
			opacity: 0.05
</style>
