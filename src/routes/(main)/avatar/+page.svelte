<script lang="ts">
	import type { PageData } from "./$types"
	import fade from "$lib/fade"
	import { fly } from "svelte/transition"

	export let data: PageData

    let modal = false
    let bodyPart = ""

    const bodyColours = [ // HEX (god have mercy on my soul this took 40 minutes to do)
        "#AFDDFF", // Pastel light blue
        "#80BBDB", // Pastel Blue
        "#6E99CA", // Medium blue
        "#0D69AC", // Bright blue
        "#0000FF", // Really blue
        "#2154B9", // Deep blue
        "#002060", // Navy blue
        "#9FF3E9", // Pastel blue-green
        "#12EED4", // Teal
        "#789082", // Sand green
        "#7F8E64", // Grime
        "#74869D", // Sand blue
        "#00FFFF", // Toothpaste
        "#04AFEC", // Cyan
        "#008F9C", // Bright bluish green
        "#CCFFCC", // Pastel green
        "#A1C48C", // Medium green
        "#A4BD47", // Br. yellowish green
        "#4B974B", // Bright green
        "#3A7D15", // Camo
        "#00FF00", // Lime green
        "#287F47", // Dark green
        "#27462D", // Earth green
        "#FFFFCC", // Pastel yellow
        "#FDEA8D", // Cool yellow
        "#C1BE42", // Olive
        "#F5CD30", // Bright yellow
        "#FFAF00", // Deep orange
        "#FFFF00", // New Yeller 
        "#E29B40", // Br. yellowish orange
        "#FFC9C9", // Pastel orange
        "#EAB892", // Light orange
        "#DA867A", // Medium red
        "#A34B4B", // Dusty Rose
        "#FF66CC", // Pink
        "#FF00BF", // Hot pink
        "#FF0000", // Really red
        "#C4281C", // Bright red
        "#E8BAC8", // Light reddish violet
        "#B1A7FF", // Pastel violet
        "#B480FF", // Alder
        "#957977", // Sand red
        "#8C5B9F", // Lavender
        "#AA00AA", // Magenta
        "#6225D1", // Royal purple
        "#6B327C", // Bright violet
        "#D7C59A", // Brick yellow
        "#FFCC99", // Pastel brown
        "#CC8E69", // Nougat
        "#DA8541", // Bright orange
        "#A05F35", // Dark orange
        "#AA5500", // CGA brown
        "#7C5C46", // Brown
        "#694028", // Reddish brown
        "#F8F8F8", // Institutional white
        "#F2F3F3", // White
        "#E5E4DF", // Light stone grey
        "#CDCDCD", // Mid gray
        "#A3A2A5", // Medium stone grey
        "#635F62", // Dark stone grey
        "#1B2A35", // Black
        "#111111" // Really black
    ]

    function openColorPicker(bodypart: string) {
        modal = true
        bodyPart = bodypart
    }

    function pickColor(color: string) {
        console.log(color)
        modal = false
    }

</script>

<div class="container">
	<h1 class="text-white">Avatar</h1>
	<code>Avatar system in alpha.</code>
	<div class="row mt-4">
		<div class="col-3">
			<div class="card mb-3">
				<div class="card-body">
					<div class="d-grid gap-2 mb-4">
						<button class="btn btn-primary" disabled><i class="fa-solid fa-rotate" /> Regenerate</button>
					</div>
					<img class="img-fluid" alt="Avatar" src="/favicon.svg" />
				</div>
			</div>
			<div class="card">
				<div class="card-header light-text">Body Colours</div>
				<div class="card-body">
					<div class="mannequin text-center">
						<div class="mx-auto" style="height:240px;width:194px;text-align:center;">
							<div style="position: relative; margin: 11px 4px; height: 1%;">
								<div style="position: absolute; left: 72px; top: 0px; cursor: pointer">
									<div class="bodyPart" on:click={() => {openColorPicker("Head")}} on:keydown={() => {openColorPicker("Head")}} style="background-color:#E5E4DF;height:44px;width:44px;" />
								</div>
								<div style="position: absolute; left: 0px; top: 52px; cursor: pointer">
									<div class="bodyPart" on:click={() => {openColorPicker("RightArm")}} on:keydown={() => {openColorPicker("Right Arm")}} data-body-part="Right Arm" style="background-color:#E5E4DF;height:88px;width:40px;" />
								</div>
								<div style="position: absolute; left: 48px; top: 52px; cursor: pointer">
									<div class="bodyPart" on:click={() => {openColorPicker("Torso")}} on:keydown={() => {openColorPicker("Torso")}} data-body-part="Torso" style="background-color:#635F62;height:88px;width:88px;" />
								</div>
								<div style="position: absolute; left: 144px; top: 52px; cursor: pointer">
									<div class="bodyPart" on:click={() => {openColorPicker("LeftArm")}} on:keydown={() => {openColorPicker("Left Arm")}} data-body-part="Left Arm" style="background-color:#E5E4DF;height:88px;width:40px;" />
								</div>
								<div style="position: absolute; left: 48px; top: 146px; cursor: pointer">
									<div class="bodyPart" on:click={() => {openColorPicker("LeftLeg")}} on:keydown={() => {openColorPicker("Left Leg")}} data-body-part="Left Leg" style="background-color:#6E99CA;height:88px;width:40px;" />
								</div>
								<div style="position: absolute; left: 96px; top: 146px; cursor: pointer">
									<div class="bodyPart" on:click={() => {openColorPicker("RightLeg")}} on:keydown={() => {openColorPicker("Right Leg")}} data-body-part="Right Leg" style="background-color:#6E99CA;height:88px;width:40px;" />
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="col">
			<div class="card">
				<div class="card-body">
                    <code>To be implemented.</code>
                </div>
			</div>
		</div>
	</div>
</div>
{#if modal}
	<div id="fade" in:fade class="vh-100 vw-100 position-absolute top-0 bg-black" />
	<div class="modal d-block" tabindex="-1" in:fly={{ y: -50 }}>
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
                <div class="modal-header">
                    <h1 class="h4 light-text">Choose a {bodyPart} color</h1>
                    <button type="button" class="btn-close" on:click={() => {modal = false}} data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
				<div class="modal-body d-flex flex-column p-1">
                    <div class="colourPicker text-left mx-auto" style="max-width:351px">
                    {#each bodyColours as colours}
                        <div class="colour m-1" on:click={() => {pickColor(colours)}} on:keydown={() => {pickColor("ya")}} style="display:inline-block;background-color:{colours};height:40px;width:40px;"></div>
                    {/each}
                    </div>
				</div>
			</div>
		</div>
	</div>
{/if}
<style lang="sass">
    .card 
        background: var(--accent)

    #fade
        opacity: 0.5
    
    .modal-content
	    background: var(--background)
        border-color: var(--accent)

    .btn-close
        filter: invert(1) grayscale(100%) brightness(200%)
</style>
