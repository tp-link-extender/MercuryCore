<script lang="ts">
	import Head from "$lib/components/Head.svelte"
	import Waves from "./Waves.svelte"
</script>

<Head
	title="Mercury: Endless possibilities. New features. Same nostalgia."
	description="Mercury: Endless possibilities. New features. Same nostalgia."
	ogImage="/mercury.gif" />

<div id="gradientbg" class="w-full h-full fixed" />

<canvas id="gradientcanvas" class="w-full h-full fixed" />

<Waves reverse />

<div class="flex flex-col justify-center items-center relative pt-40vh">
	<h1 class="font-bold opacity-75 text-14">Mercury Core</h1>
	<p class="text-center">Mercury core has successfully been set up!</p>
	<div class="inline pb-2">
		<a type="button" href="/login" class="inline btn btn-sm btn-secondary">
			<b>Login</b>
			<fa fa-right-to-bracket class="pl-1" />
		</a>
		<a type="button" href="/register" class="inline btn btn-sm btn-primary">
			<b>Register</b>
			<fa fa-plus class="pl-1" />
		</a>
	</div>
</div>

<style>
	#gradientbg {
		background: linear-gradient(25deg, #2b0574, #060e25, #161a92, #6c2fb9);
	}
</style>
