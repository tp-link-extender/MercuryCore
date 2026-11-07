<script lang="ts">
	import { isValidMapName, mapNamePattern } from "$lib/mapName"

	const {
		beginJoining,
		scheme,
		serverTicket,
		domain,
		siteName
	}: {
		beginJoining(joinscripturl: () => string): () => void
		scheme: string
		serverTicket: string
		domain: string
		siteName: string
	} = $props()

	let filepath = $state("")

	let validMap = $derived(filepath === "" || isValidMapName(filepath))

	const encodeMap = (value: string): string =>
		btoa(String.fromCodePoint(...new TextEncoder().encode(value)))

	let host = $derived(
		beginJoining(
			() =>
				// TODO: fix hosting and map opening with correct URI scheme
				`${scheme}20131+launchmode:ide+script:http://${domain}/game/host?ticket=${serverTicket}&autopilot=${encodeMap(
					filepath
				)}`
		)
	)
</script>

<p>
	Autopilot manages initial Studio operations. All you need to do is type in a
	map that's in the map folder, and start the server.
</p>
<p>
	Place your maps in {siteName} Studio's maps folder. For example, entering
	<code>CoolMap.rbxl</code>
	will point to
	<code>content/maps/CoolMap.rbxl</code>
</p>
<div class="input-group">
	<input
		type="text"
		id="filepath"
		bind:value={filepath}
		placeholder="Map location"
		aria-label="Map location"
		aria-invalid={!validMap}
		pattern={mapNamePattern.source}
		maxlength={69}
		title="Map names may use letters, numbers, spaces, dots, underscores and hyphens, and must end in .rbxl." />
	<button
		class="btn btn-secondary"
		onclick={beginJoining(() => `${scheme}20131+launchmode:maps`)}
		type="button">
		<fa fa-arrow-up-right-from-square></fa>
		Map Folder
	</button>
	<button
		class="btn btn-primary"
		onclick={host}
		type="button"
		disabled={!validMap}>
		<fa fa-wifi></fa>
		Begin Hosting
	</button>

	<div class="dropdown">
		<div
			class="btn btn-tertiary dropdown-toggle border-[--accent2] rounded-l-0">
		</div>
		<div class="dropdown-content pt-2">
			<ul class="p-2 rounded-3">
				<li class="rounded-2">
					<button
						class="btn light-text pl-4 pr-0 text-start"
						onclick={host}
						type="button"
						disabled={!validMap}>
						Begin Hosting (no Studio tools)
					</button>
				</li>
			</ul>
		</div>
	</div>
</div>

{#if !validMap}
	<small class="text-red-500">
		Map names may only use letters, numbers, spaces, dots, underscores and
		hyphens, and must end in .rbxl.
	</small>
{/if}

<style>
	.dropdown-toggle::after {
		/* funny down arrow */
		display: inline-block;
		vertical-align: 0.255rem;
		content: "";
		border-top: 0.3rem solid;
		border-right: 0.3rem solid transparent;
		border-left: 0.3rem solid transparent;
	}
</style>
