<script lang="ts">
	import Head from "$lib/components/Head.svelte"
	import Waves from "./Waves.svelte"

	const systems = [
		["Server", ["You are running", "DEVELOPMENT"]],
		[
			"Database",
			["Connected to", "surrealdb-1.5.3", "with", "CustomHttpEngine"]
		],
		["Client API", ["Connected with", "200 OK"]],
		["Economy Service", ["Current stipend size is", "10.000000", "unit"]],
		["RCCService", ["Connected with", "0", "jobs running"]],
		["Reverse proxy", ["Rewrite of", "setup", "subdomain successful"]],
		["Asset cache", ["Connected with", "4", "assets cached"]],
		["Hotel?", ["", "Trivago"]]
	]
</script>

<Head
	title="Mercury: Endless possibilities. New features. Same nostalgia."
	description="Mercury: Endless possibilities. New features. Same nostalgia."
	ogImage="/mercury.gif" />

<div id="gradientbg" class="w-full h-full fixed" />

<canvas id="gradientcanvas" class="w-full h-full fixed" />

<Waves reverse />

<div
	class="grid grid-cols-2 absolute w-250 absolute left-1/2 -translate-x-1/2 pt-10vh">
	<div class="flex flex-col justify-center">
		<h1 class="font-bold text-14">
			Mercury <span class="opacity-50">Core</span>
		</h1>
		<div class="py-6">
			{#each systems as [name, status]}
				<div class="flex items-center py-3">
					<far class="text-4xl fa-check-circle text-emerald-6" />
					<div class="pl-4">
						<div class="text-7 font-500 light-text line-height-5">
							{name}
						</div>
						<p class="p-0">
							{#each status as stat, i}
								<small
									class="text-3.5 font-500 {i % 2 == 0
										? 'opacity-60'
										: 'text-emerald-2'}">
									{stat}
								</small>
							{/each}
						</p>
					</div>
				</div>
			{/each}
		</div>
		<p>Mercury core has successfully been set up!</p>
		<div class="inline pb-2">
			<a
				type="button"
				href="/login"
				class="inline btn btn-sm btn-secondary">
				<b>Login</b>
				<fa fa-right-to-bracket class="pl-1" />
			</a>
			<a
				type="button"
				href="/register"
				class="inline btn btn-sm btn-primary">
				<b>Register</b>
				<fa fa-plus class="pl-1" />
			</a>
		</div>
	</div>
	<div class="flex flex-col items-center justify-center">
		<h1 class="font-normal text-8 mb--2">
			<div class="underline-#5a8e99">if you can see this.</div>
			<div class="underline-#caafa8">that means your installation</div>
			<div class="underline-#dbdbe3">of Mercury Core is working!</div>
		</h1>
		<img src="/landing/working.svg" alt="Mercury" />
	</div>
</div>

<style>
	#gradientbg {
		background: linear-gradient(
			10deg,
			#6c2fb9,
			#161a92,
			#2b0574,
			#060e25 30%,
			var(--darker) 80%
		);
	}
	h1 div {
		@apply underline underline-1.5px;
	}
</style>
