<script lang="ts">
	export let reverse = false
</script>

<span
	class="w-full h-full absolute top-0 overflow-hidden pointer-events-none"
	style="--margin-1: {reverse ? 0 : -1600}px; --margin-2: {reverse
		? -1600
		: 0}px">
	<div class="w-full fixed bottom-0 z-1">
		<div class="absolute -top-198px h-198px w-1536" />
		<div class="absolute -top-174px h-198px w-1536" />
	</div>
</span>

<style>
	@keyframes waves {
		0% {
			margin-left: var(--margin-1);
		}
		100% {
			margin-left: var(--margin-2);
		}
	}

	div div {
		background: url(/landing/wave.svg) repeat-x;
		animation: 11s cubic-bezier(0.36, 0.45, 0.63, 0.53) 0s infinite normal
			none running waves;
		transform: translate3d(0px, 0px, 0px);
	}
	div div:nth-of-type(2) {
		animation:
			11s cubic-bezier(0.4, 0.2, 0.2, 0.2) -0.124s infinite normal none running
				waves,
			11s ease -1.24s infinite normal none running swell;
	}
</style>
