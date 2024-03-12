<svelte:head>
	<script>
		var direction1 = -1600
		var time = 22000
		$(document).ready(function () {
			function anim() {
				$("#w1").animate(
					// alternate between margin-left -1600 and 0px
					{ marginLeft: direction1 },
					time,
					function() {
						direction1 = -1600 - direction1
						anim()
					}
				)
				$("#w2").animate(
					// move 40% of the distance at first
					{ marginLeft: -800 },
					time * 0.47,
					function() {
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
