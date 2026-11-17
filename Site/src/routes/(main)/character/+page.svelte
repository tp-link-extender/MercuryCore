<script lang="ts">
	import TabData from "#components/TabData.ts"
	import TabNav from "#components/TabNav.svelte"
	import { brickColours, brickToHex } from "#lib/brickColours.ts"
	import AvatarItem from "./AvatarItem.svelte"
	import { paintForm, regenForm } from "./character.remote"

	const { data } = $props()

	let { user } = $derived(data)

	// Every render is requested server-side, so a changing query string shows the new one instead of the browser's cached copy
	let avatarVersion = $state(0)
	const avatarUrl = $derived(
		`/api/avatar/${user.username}-body?r=${avatarVersion}`
	)

	const tabTypes: { [_: string]: number } = Object.freeze({
		Faces: 18,
		Gear: 19,
		Hats: 8,
		Heads: 17,
		"Left Arm": 29,
		"Left Leg": 30,
		Packages: 32, 
		Pants: 12,
		Recent: 0,
		"Right Arm": 28,
		"Right Leg": 31,
		Shirts: 11,
		"T-Shirts": 2,
		Torso: 27
	})
	const bodyPartTabs = Object.freeze({
		Faces: 18,
		Heads: 17,
		"Left Arm": 29,
		"Left Leg": 30,
		"Right Arm": 28,
		"Right Leg": 31, 
		Torso: 27
	})
	let tabData = $state(
		TabData(data.url, Object.keys(tabTypes), undefined, "tab", [
			{ name: "Body Parts", tabs: Object.keys(bodyPartTabs) }
		])
	)

	const bodyParts: { [_: string]: number } = $state({
		Head: user.bodyColours.Head,
		LeftArm: user.bodyColours.LeftArm,
		LeftLeg: user.bodyColours.LeftLeg,
		RightArm: user.bodyColours.RightArm,
		RightLeg: user.bodyColours.RightLeg, 
		Torso: user.bodyColours.Torso
	})
	const bodyPartPopovers: { [_: string]: HTMLDivElement } = $state({})
	const styles: { [_: string]: string } = Object.freeze({
		Head: "left-17 size-12",
		LeftArm: "left-0 top-14 h-22 w-10",
		LeftLeg: "left-12 top-38 h-22 w-10",
		RightArm: "left-36 top-14 h-22 w-10",
		RightLeg: "left-24 top-38 h-22 w-10", 
		Torso: "left-12 top-14 size-22"
	})

	let assets = $derived(
		data.assets.filter(a =>
			tabData.currentTab === "Recent"
				? true
				: tabData.currentTab === "Body Parts"
					? // all body part types at once
						(Object.values(bodyPartTabs) as number[]).includes(a.type)
					: a.type === tabTypes[tabData.currentTab]
		)
	)
</script>

<div class="ctnr light-text">
	<h1>Character</h1>
	<div class="grid lg:grid-cols-4 gap-4 pt-6">
		<div class="<md:col-span-3 flex lg:flex-col gap-4">
			<div class="card w-full p-4">
				<form
					{...regenForm}
					onsubmit={() => {
						avatarVersion++
					}}>
					<button class="btn btn-secondary w-full">
						<fa fa-rotate></fa>
						Regenerate
					</button>
				</form>
				<img
					alt="Your character"
					class={[
						"w-full transition-opacity duration-300",
						{ "opacity-50": regenForm.pending > 0 }
					]}
					src={avatarUrl} />
			</div>
			<div class="card w-full p-4">
				Body colours
				<div class="flex justify-center pt-4">
					<div class="relative h-60 w-46">
						{#each Object.keys(bodyParts) as bodyPart}
							<button
								popovertarget={bodyPart}
								style="background-color: #{brickToHex[
									bodyParts[bodyPart]
								]}"
								class="btn bodyPart absolute p-0 {styles[
									bodyPart
								]}"
								aria-label={bodyPart}>
							</button>
						{/each}
					</div>
				</div>
			</div>
		</div>
		<div class="col-span-3">
			<TabNav bind:tabData justify />
			{#if assets.length > 0}
				<div
					class="grid xl:grid-cols-6 sm:grid-cols-4 grid-cols-3 gap-4">
					{#each assets || [] as asset, num}
						<AvatarItem
							{asset}
							{num}
							total={(assets || []).length} />
					{/each}
				</div>
			{:else if tabData.currentTab === "Recent"}
				<h2 class="text-center">No recently worn items.</h2>
			{:else}
				<h2 class="text-center">
					You don't have any {tabData.currentTab} yet.
				</h2>
				<h3 class="pt-4 text-center">
					Head to the
					<a href="/catalog?tab={tabData.currentTab}">Catalog</a>
					to get some!
				</h3>
			{/if}
		</div>
	</div>
</div>

{#each Object.keys(bodyParts) as bodyPart}
	<div
		bind:this={bodyPartPopovers[bodyPart]}
		id={bodyPart}
		popover="auto"
		class="light-text p-4">
		<h1 class="text-lg pb-2">Choose a {bodyPart} color</h1>
		<div class="text-left max-w-108 flex flex-wrap gap-2">
			{#each brickColours as colour}
				<form
					{...paintForm}
					onsubmit={() => {
						bodyParts[bodyPart] = colour
						avatarVersion++
						bodyPartPopovers[bodyPart].hidePopover()
					}}
					class="inline">
					<input
						{...paintForm.fields.p.as("hidden", bodyPart)} />
					<input
						{...paintForm.fields.c.as(
							"hidden",
							colour.toString()
						)} />
					<button
						class="btn colour size-10"
						style="background-color: #{brickToHex[colour]}"
						aria-label={colour.toString()}>
					</button>
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
		transition: all 0.2s ease-out;
		&:hover {
			filter: brightness(70%);
		}
	}
</style>
