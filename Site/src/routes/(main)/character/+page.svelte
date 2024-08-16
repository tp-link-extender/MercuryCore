<script lang="ts">
	import { browser } from "$app/environment"
	import { applyAction } from "$app/forms"
	import { enhance } from "$app/forms"
	import { invalidateAll } from "$app/navigation"
	import TabData from "$components/TabData"
	import TabNav from "$components/TabNav.svelte"
	import { brickColours, brickToHex } from "$lib/brickColours"
	import AvatarItem from "./AvatarItem.svelte"

	export let data
	export let form

	const { user } = data

	let query = data.query
	let searchedData: typeof data.assets = []
	let regenerating = false

	const enhanceRegen: import("./$types").SubmitFunction = () => {
		regenerating = true
		return async ({ result }) => {
			if (result.type === "success") await invalidateAll()
			await applyAction(result)
			regenerating = false
		}
	}

	// Run function whenever query changes
	async function search() {
		if (query.trim().length === 0) {
			searchedData = data.assets
			return
		}

		const response = await fetch(`/character/search?q=${query}`)
		searchedData = (await response.json()).data.assets as typeof data.assets
	}
	$: query && browser && search()

	export const snapshot = {
		capture: () => query,
		restore: v => {
			query = v
		}
	}

	const tabTypes: { [k: string]: number } = Object.freeze({
		Recent: 0,
		Hats: 8,
		Heads: 17,
		Faces: 18,
		"T-Shirts": 2,
		Shirts: 11,
		Pants: 12,
		Gear: 19
	})
	let tabData = TabData(data.url, Object.keys(tabTypes))

	const bodyParts: { [k: string]: number } = {
		Head: user.bodyColours.Head,
		Torso: user.bodyColours.Torso,
		LeftArm: user.bodyColours.LeftArm,
		RightArm: user.bodyColours.RightArm,
		LeftLeg: user.bodyColours.LeftLeg,
		RightLeg: user.bodyColours.RightLeg
	}
	const bodyPartModals: { [k: string]: HTMLDivElement } = {}
	const styles: { [k: string]: string } = Object.freeze({
		Head: "left-17 size-12",
		Torso: "left-12 top-14 size-22",
		LeftArm: "left-0 top-14 h-22 w-10",
		RightArm: "left-36 top-14 h-22 w-10",
		LeftLeg: "left-12 top-38 h-22 w-10",
		RightLeg: "left-24 top-38 h-22 w-10"
	})

	$: assets = (query && browser ? searchedData : data.assets || []).filter(
		a =>
			tabData.currentTab === "Recent"
				? true
				: a.type === tabTypes[tabData.currentTab]
	)
</script>

<div class="ctnr light-text">
	<h1>Character</h1>
	<div class="grid lg:grid-cols-4 gap-4 pt-6">
		<div class="<md:col-span-3 flex lg:flex-col gap-4">
			<div class="card w-full p-4">
				<form use:enhance={enhanceRegen} method="POST" action="?/regen">
					<button class="btn btn-secondary w-full">
						<fa fa-rotate />
						Regenerate
					</button>
				</form>
				<p class="text-red-5">
					{form?.msg || ""}
				</p>
				<img
					alt="Your character"
					class:opacity-50={regenerating}
					class="w-full transition-opacity duration-300"
					src={form?.avatar || `/api/avatar/${user.username}-body`} />
			</div>
			<div class="card w-full p-4">
				Body Colours
				<div class="mx-auto h-240px w-194px text-center">
					<div class="parts relative">
						{#each Object.keys(bodyParts) as bodyPart}
							<button
								popovertarget={bodyPart}
								style="background-color: #{brickToHex[
									bodyParts[bodyPart]
								]}"
								class="btn bodyPart absolute p-0 {styles[
									bodyPart
								]}" />
						{/each}
					</div>
				</div>
			</div>
		</div>
		<div class="col-span-3">
			<TabNav bind:tabData justify />
			<form
				on:submit|preventDefault
				action="/character?tab={tabData.currentTab}"
				class="input-group pb-4">
				<input
					bind:value={query}
					type="text"
					name="q"
					placeholder="Search for an item"
					aria-label="Search for an item"
					aria-describedby="button-addon2" />
				<input type="hidden" name="tab" value={tabData.currentTab} />
				<button
					class="btn btn-secondary"
					aria-label="Search"
					id="button-addon2">
					<fa fa-magnifying-glass />
				</button>
			</form>
			{#if query && assets.length === 0}
				<h2 class="text-xs pt-12">
					{#if tabData.currentTab === "Recent"}
						No recently worn items found with search term {query}
					{:else}
						No {tabData.currentTab} found with search term {query}
					{/if}
				</h2>
			{:else}
				<div
					class="grid xl:grid-cols-6 sm:grid-cols-4 grid-cols-3 gap-4">
					{#each assets || [] as asset, num}
						<AvatarItem
							{asset}
							{num}
							total={(assets || []).length}
							currentTab={tabData.currentTab}
							{enhanceRegen} />
					{/each}
				</div>
			{/if}
		</div>
	</div>
</div>

{#each Object.keys(bodyParts) as bodyPart}
	<div
		bind:this={bodyPartModals[bodyPart]}
		id={bodyPart}
		popover="auto"
		class="light-text p-4">
		<h1 class="text-lg pb-2">Choose a {bodyPart} color</h1>
		<div class="text-left max-w-108 flex flex-wrap gap-2">
			{#each brickColours as colour}
				<form
					use:enhance={enhanceRegen}
					method="POST"
					action="?/paint&p={bodyPart}&c={colour}"
					on:submit={() => {
						bodyParts[bodyPart] = colour
						bodyPartModals[bodyPart].hidePopover()
					}}
					class="inline">
					<button
						class="btn colour size-10"
						style="background-color: #{brickToHex[colour]}" />
				</form>
			{/each}
		</div>
	</div>
{/each}

<style>
	.card {
		border: 1px solid var(--accent2);
	}

	.bodyPart {
		border-radius: 3px;
		&:first-child {
			border-radius: 12px;
		}
	}

	.bodyPart,
	.colour {
		transition: filter 0.2s ease-out;
		&:hover {
			filter: brightness(70%);
		}
	}

	.parts {
		margin: 11px 0px 0px 36px;
		@media (max-width: 639.9px) {
			margin: 11px 4px 0px 7px;
		}
		@media (min-width: 640px) {
			margin: 11px 4px 0px 7px;
		}
		@media (min-width: 768px) {
			margin: 11px 4px 0px 9px;
		}
		@media (min-width: 1024px) {
			margin: 11px 4px 0px -8px;
		}
		@media (min-width: 1280px) {
			margin: 11px 0px 0px 7px;
		}
	}
</style>
