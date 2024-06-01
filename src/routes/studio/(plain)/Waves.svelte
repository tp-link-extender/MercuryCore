<svelte:head>
	<script>
		// biome-ignore lint:
		var direction1 = -1600
		// biome-ignore lint:
		var time = 22000
		// biome-ignore lint:
		$(document).ready(function () {
			function anim() {
				$("#w1").animate(
					// alternate between margin-left -1600 and 0px
					{ marginLeft: direction1 },
					time,
					// biome-ignore lint:
					function () {
						direction1 = -1600 - direction1
						anim()
					}
				)
				$("#w2").animate(
					// move 40% of the distance at first
					{ marginLeft: -800 },
					time * 0.47,
					// biome-ignore lint:
					function () {
						$("#w2").animate(
							// alternate between margin-left -1600 and 0px
							{ marginLeft: direction1 },
							time * 0.53
						)
					}
				)
			}
			anim()
		})
	</script>
</svelte:head>

<span class="w-full h-full absolute top-0 overflow-hidden pointer-events-none">
	<div class="w-full fixed bottom-0">
		<div id="w1" class="absolute -top-198px h-198px w-1536" />
		<div id="w2" class="absolute -top-174px h-198px w-1536" />
	</div>
</span>

<style lang="stylus">
	div div
		background url("/landing/wave.svg") repeat-x
		transform translate3d(0px, 0px, 0px)
</style>
