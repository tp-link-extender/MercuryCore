<script lang="ts">
	import { VERSION } from "@sveltejs/kit"
	import Head from "$components/Head.svelte"
	import beautifyCurrency from "$lib/beautifyCurrency"
	import Waves from "./Waves.svelte"

	const { data } = $props()

	const [, c1, c2] = data.stipend.ok
		? beautifyCurrency(data.stipend.value)
		: ["", "", ""]

	const systems = [
		{
			name: "Mercury Core",
			ok: true,
			success: [
				"Running",
				`SvelteKit ${VERSION}`,
				"in",
				"development",
				"mode"
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
				"Current stipend value is",
				`${data.currencySymbol}${c1}${c2 ? "." : ""}${c2}`
			],
			err: "Unable to connect to the service"
		}
	]
	const working = systems.every(s => s.ok)
</script>

<Head name={data.siteName} title={data.siteName} description={data.siteName} />

<div id="gradientbg" class="w-full h-full fixed"></div>

<canvas id="gradientcanvas" class="w-full h-full fixed"></canvas>

<Waves reverse />

<div
	class="grid md:grid-cols-[3fr_2fr] justify-center px-6 absolute w-full max-w-250 absolute left-1/2 -translate-x-1/2 pt-25vh">
	<div class="flex flex-col flex-wrap justify-center">
		<h1 class="font-bold text-14">
			Mercury <span class="opacity-50">Core</span>
		</h1>
		<div class="py-6">
			{#each systems as { name, ok, success, err }}
				<div class="flex items-center py-3">
					<fa
						class="text-4xl {ok
							? 'fa-check-circle text-emerald-500'
							: 'fa-circle-ellipsis text-neutral-300'}">
					</fa>
					<div class="pl-4">
						<div class=" light-text text-7 font-500 line-height-5">
							{name}
						</div>
						<p class="p-0">
							{#if ok}
								{#each success as stat, i}
									<small
										class="text-3.5 font-500 pr-1 {i % 2 ==
										0
											? 'opacity-60'
											: 'text-emerald-200'}">
										{stat}
									</small>
								{/each}
							{:else}
								<small class="text-3.5 font-500 text-red-200">
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
				<b>Log in</b>
				<fa fa-right-to-bracket class="pl-1"></fa>
			</a>
			<a
				type="button"
				href="/register"
				class="btn btn-sm btn-primary inline">
				<b>Register</b>
				<fa fa-plus class="pl-1"></fa>
			</a>
		</div>
	</div>
	{#if working}
		<div class="flex justify-center pt-9">
			<p class="font-normal text-4 pt-9 max-w-50">
				If you can see this, that means your installation of Mercury
				Core is working!
			</p>
			<img
				src="/landing/working.svg"
				alt="Alonso reference"
				class="w-35" />
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
