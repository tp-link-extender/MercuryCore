<script lang="ts">
	import { dev } from "$app/environment"
	import Head from "$components/Head.svelte"
	import beautifyCurrency from "$lib/beautifyCurrency"
	import { VERSION } from "@sveltejs/kit"
	import Waves from "./Waves.svelte"

	export let data

	const [, c1, c2] = data.stipend.ok
		? beautifyCurrency(data.stipend.value)
		: ["", "", ""]

	const systems = [
		{
			name: "Mercury Core",
			ok: true,
			success: [
				"Running SvelteKit",
				VERSION,
				"in",
				dev ? "DEVELOPMENT" : "PRODUCTION"
			],
			err: ""
		},
		{
			name: "Database",
			ok: true,
			success: ["Connected to", data.database],
			err: ""
		},
		{
			name: "Economy Service",
			ok: data.stipend.ok,
			success: [
				"Current stipend size is",
				`${data.currencySymbol}${c1}${c2 ? "." : ""}${c2}`
			],
			err: "Unable to connect to the service"
		}
	]
	const working = systems.every(s => s.ok)
</script>

<Head name={data.siteName} title={data.siteName} description={data.siteName} />

<div id="gradientbg" class="w-full h-full fixed" />

<canvas id="gradientcanvas" class="w-full h-full fixed" />

<Waves reverse />

<div
	class="flex justify-center absolute w-250 absolute left-1/2 -translate-x-1/2 pt-25vh">
	<div class="flex flex-col justify-center w-1/2">
		<h1 class="font-bold text-14">
			Mercury <span class="opacity-50">Core</span>
		</h1>
		<div class="py-6">
			{#each systems as { name, ok, success, err }}
				<div class="flex items-center py-3">
					<fa
						class="text-4xl {ok
							? 'fa-check-circle text-emerald-5'
							: 'fa-circle-ellipsis text-neutral-3'}" />
					<div class="pl-4">
						<div class=" light-text text-7 font-500 line-height-5">
							{name}
						</div>
						<p class="p-0">
							{#if ok}
								{#each success as stat, i}
									<small
										class="text-3.5 font-500 {i % 2 == 0
											? 'opacity-60'
											: 'text-emerald-2'}">
										{stat}
									</small>
								{/each}
							{:else}
								<small class="text-3.5 font-500 text-red-2">
									{err}
								</small>
							{/if}
						</p>
					</div>
				</div>
			{/each}
		</div>
		<div class="inline pb-2">
			<a
				type="button"
				href="/login"
				class="btn btn-sm btn-secondary inline">
				<b>Login</b>
				<fa fa-right-to-bracket class="pl-1" />
			</a>
			<a
				type="button"
				href="/register"
				class="btn btn-sm btn-primary inline">
				<b>Register</b>
				<fa fa-plus class="pl-1" />
			</a>
		</div>
	</div>
	{#if working}
		<div class="flex justify-center w-1/2">
			<p class="font-normal text-6 pt-9">
				If you can see this, that means your installation of Mercury
				Core is working!
			</p>
			<img src="/landing/working.svg" alt="Alonso reference" class="w-50" />
		</div>
	{/if}
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
</style>
