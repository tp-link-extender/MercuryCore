<script lang="ts">
	import Modal from "$lib/components/Modal.svelte"
	import { writable } from "svelte/store"
	import { enhance } from "$app/forms"
	import { getUser } from "@lucia-auth/sveltekit/client"

	const user = getUser()

	let modal = writable(false)
	let bodyPart = ""

	const bodyColours = [
		// HEX (god have mercy on my soul this took 40 minutes to do)
		"AFDDFF", // Pastel light blue
		"80BBDB", // Pastel Blue
		"6E99CA", // Medium blue
		"0D69AC", // Bright blue
		"0000FF", // Really blue
		"2154B9", // Deep blue
		"002060", // Navy blue
		"9FF3E9", // Pastel blue-green
		"12EED4", // Teal
		"789082", // Sand green
		"7F8E64", // Grime
		"74869D", // Sand blue
		"00FFFF", // Toothpaste
		"04AFEC", // Cyan
		"008F9C", // Bright bluish green
		"CCFFCC", // Pastel green
		"A1C48C", // Medium green
		"A4BD47", // Br. yellowish green
		"4B974B", // Bright green
		"3A7D15", // Camo
		"00FF00", // Lime green
		"287F47", // Dark green
		"27462D", // Earth green
		"FFFFCC", // Pastel yellow
		"FDEA8D", // Cool yellow
		"C1BE42", // Olive
		"F5CD30", // Bright yellow
		"FFAF00", // Deep orange
		"FFFF00", // New Yeller
		"E29B40", // Br. yellowish orange
		"FFC9C9", // Pastel orange
		"EAB892", // Light orange
		"DA867A", // Medium red
		"A34B4B", // Dusty Rose
		"FF66CC", // Pink
		"FF00BF", // Hot pink
		"FF0000", // Really red
		"C4281C", // Bright red
		"E8BAC8", // Light reddish violet
		"B1A7FF", // Pastel violet
		"B480FF", // Alder
		"957977", // Sand red
		"8C5B9F", // Lavender
		"AA00AA", // Magenta
		"6225D1", // Royal purple
		"6B327C", // Bright violet
		"D7C59A", // Brick yellow
		"FFCC99", // Pastel brown
		"CC8E69", // Nougat
		"DA8541", // Bright orange
		"A05F35", // Dark orange
		"AA5500", // CGA brown
		"7C5C46", // Brown
		"694028", // Reddish brown
		"F8F8F8", // Institutional white
		"F2F3F3", // White
		"E5E4DF", // Light stone grey
		"CDCDCD", // Mid gray
		"A3A2A5", // Medium stone grey
		"635F62", // Dark stone grey
		"1B2A35", // Black
		"111111", // Really black
	]

	const brickToHex: any = {
		1: "F2F3F3",
		2: "A1A5A2",
		3: "F9E999",
		5: "D7C59A",
		6: "C2DAB8",
		9: "E8BAC8",
		11: "80BBDC",
		12: "CB8442",
		18: "CC8E69",
		21: "C4281C",
		22: "C470A0",
		23: "0D69AC",
		24: "F5CD30",
		25: "624732",
		26: "1B2A35",
		27: "6D6E6C",
		28: "287F47",
		29: "A1C48C",
		36: "F3CF9B",
		37: "4B974B",
		38: "A05F35",
		39: "C1CADE",
		40: "ECECEC",
		41: "CD544B",
		42: "C1DFF0",
		43: "7BB6E8",
		44: "F7F18D",
		45: "B4D2E4",
		47: "D9856C",
		48: "84B68D",
		49: "F8F184",
		50: "ECE8DE",
		100: "EEC4B6",
		101: "DA867A",
		102: "6E99CA",
		103: "C7C1B7",
		104: "6B327C",
		105: "E29B40",
		106: "DA8541",
		107: "008F9C",
		108: "685C43",
		110: "435493",
		111: "BFB7B1",
		112: "6874AC",
		113: "E5ADC8",
		115: "C7D23C",
		116: "55A5AF",
		118: "B7D7D5",
		119: "A4BD47",
		120: "D9E4A7",
		121: "E7AC58",
		123: "D36F4C",
		124: "923978",
		125: "EAB892",
		126: "A5A5CB",
		127: "DCBC81",
		128: "AE7A59",
		131: "9CA3A8",
		133: "D5733D",
		134: "D8DD56",
		135: "74869D",
		136: "877C90",
		137: "E09864",
		138: "958A73",
		140: "203A56",
		141: "27462D",
		143: "CFE2F7",
		145: "7988A1",
		146: "958EA3",
		147: "938767",
		148: "575857",
		149: "161D32",
		150: "ABADAC",
		151: "789082",
		153: "957977",
		154: "7B2E2F",
		157: "FFF67B",
		158: "E1A4C2",
		168: "756C62",
		176: "97695B",
		178: "B48455",
		179: "898788",
		180: "D7A94B",
		190: "F9D62E",
		191: "E8AB2D",
		192: "694028",
		193: "CF6024",
		194: "A3A2A5",
		195: "4667A4",
		196: "23478B",
		198: "8E4285",
		199: "635F62",
		200: "828A5D",
		208: "E5E4DF",
		209: "B08E44",
		210: "709578",
		211: "79B5B5",
		212: "9FC3E9",
		213: "6C81B7",
		216: "904C2A",
		217: "7C5C46",
		218: "96709F",
		219: "6B629B",
		220: "A7A9CE",
		221: "CD6298",
		222: "E4ADC8",
		223: "DC9095",
		224: "F0D5A0",
		225: "EBB87F",
		226: "FDEA8D",
		232: "7DBBDD",
		268: "342B75",
		301: "506D54",
		302: "5B5D69",
		303: "0010B0",
		304: "2C651D",
		305: "527CAE",
		306: "335882",
		307: "102ADC",
		308: "3D1585",
		309: "348E40",
		310: "5B9A4C",
		311: "9FA1AC",
		312: "592259",
		313: "1F801D",
		314: "9FADC0",
		315: "0989CF",
		316: "7B007B",
		317: "7C9C6B",
		318: "8AAB85",
		319: "B9C4B1",
		320: "CACBD1",
		321: "A75E9B",
		322: "7B2F7B",
		323: "94BE81",
		324: "A8BD99",
		325: "DFDFDE",
		327: "970000",
		328: "B1E5A6",
		329: "98C2DB",
		330: "FF98DC",
		331: "FF5959",
		332: "750000",
		333: "EFB838",
		334: "F8D96D",
		335: "E7E7EC",
		336: "C7D4E4",
		337: "FF9494",
		338: "BE6862",
		339: "562424",
		340: "F1E7C7",
		341: "FEF3BB",
		342: "E0B2D0",
		343: "D490BD",
		344: "965555",
		345: "8F4C2A",
		346: "D3BE96",
		347: "E2DCBC",
		348: "EDEAEA",
		349: "E9DADA",
		350: "883E3E",
		351: "BC9B5D",
		352: "C7AC78",
		353: "CABFA3",
		354: "BBB3B2",
		355: "6C584B",
		356: "A0844F",
		357: "958988",
		358: "ABA89E",
		359: "AF9483",
		360: "966766",
		361: "564236",
		362: "7E683F",
		363: "69665C",
		364: "5A4C42",
		365: "6A3909",
		1001: "F8F8F8",
		1002: "CDCDCD",
		1003: "111111",
		1004: "FF0000",
		1005: "FFB000",
		1006: "B480FF",
		1007: "A34B4B",
		1008: "C1BE42",
		1009: "FFFF00",
		1010: "0000FF",
		1011: "002060",
		1012: "2154B9",
		1013: "04AFEC",
		1014: "AA5500",
		1015: "AA00AA",
		1016: "FF66CC",
		1017: "FFAF00",
		1018: "12EED4",
		1019: "00FFFF",
		1020: "00FF00",
		1021: "3A7D15",
		1022: "7F8E64",
		1023: "8C5B9F",
		1024: "AFDDFF",
		1025: "FFC9C9",
		1026: "B1A7FF",
		1027: "9FF3E9",
		1028: "CCFFCC",
		1029: "FFFFCC",
		1030: "FFCC99",
		1031: "6225D1",
		1032: "FF00BF",
	}

	const openColorPicker = (bodypart: string) => () => {
		modal.set(true)
		bodyPart = bodypart
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
						<button class="btn btn-primary" disabled>
							<i class="fa-solid fa-rotate" />
							Regenerate
						</button>
					</div>
					<img class="img-fluid" alt="Avatar" src="/favicon.svg" />
				</div>
			</div>
			<div class="card">
				<div class="card-header light-text">Body Colours</div>
				<div class="card-body">
					<div class="mannequin text-center">
						<div
							class="mx-auto"
							style="height:240px;width:194px;text-align:center;">
							<div style="position: relative; margin: 11px 4px;">
								<div
									style="position: absolute; left: 68px; top: -4px; cursor: pointer">
									<div
										class="bodyPart"
										id="Head"
										on:click={openColorPicker("Head")}
										on:keydown={openColorPicker("Head")}
										style="background-color:#{brickToHex[
											$user?.bodyColours['Head']
										]};height:48px;width:48px;" />
								</div>
								<div
									style="position: absolute; left: 1px; top: 52px; cursor: pointer">
									<div
										class="bodyPart"
										on:click={openColorPicker("RightArm")}
										on:keydown={openColorPicker("RightArm")}
										style="background-color:#{brickToHex[
											$user?.bodyColours['RightArm']
										]};height:88px;width:40px;" />
								</div>
								<div
									style="position: absolute; left: 48px; top: 52px; cursor: pointer">
									<div
										class="bodyPart"
										on:click={openColorPicker("Torso")}
										on:keydown={openColorPicker("Torso")}
										style="background-color:#{brickToHex[
											$user?.bodyColours['Torso']
										]};height:88px;width:88px;" />
								</div>
								<div
									style="position: absolute; left: 144px; top: 52px; cursor: pointer">
									<div
										class="bodyPart"
										on:click={openColorPicker("LeftArm")}
										on:keydown={openColorPicker("LeftArm")}
										style="background-color:#{brickToHex[
											$user?.bodyColours['LeftArm']
										]};height:88px;width:40px;" />
								</div>
								<div
									style="position: absolute; left: 48px; top: 146px; cursor: pointer">
									<div
										class="bodyPart"
										on:click={openColorPicker("LeftLeg")}
										on:keydown={openColorPicker("LeftLeg")}
										style="background-color:#{brickToHex[
											$user?.bodyColours['LeftLeg']
										]};height:88px;width:40px;" />
								</div>
								<div
									style="position: absolute; left: 96px; top: 146px; cursor: pointer">
									<div
										class="bodyPart"
										on:click={openColorPicker("RightLeg")}
										on:keydown={openColorPicker("RightLeg")}
										style="background-color:#{brickToHex[
											$user?.bodyColours['RightLeg']
										]};height:88px;width:40px;" />
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

{#if $modal}
	<Modal {modal}>
		<div class="modal-header">
			<h1 class="h4 light-text">Choose a {bodyPart} color</h1>
			<button
				type="button"
				class="btn-close"
				on:click={() => modal.set(false)}
				data-bs-dismiss="modal"
				aria-label="Close" />
		</div>
		<div class="modal-body d-flex flex-column p-1">
			<div class="colourPicker text-left mx-auto" style="max-width:351px">
				{#each bodyColours as colour}
					<form
						use:enhance
						method="POST"
						action="?/paint"
						class="d-inline">
						<input type="hidden" name="bodyColour" value={colour} />
						<input type="hidden" name="bodyPart" value={bodyPart} />
						<button
							class="colour m-1"
							type="submit"
							on:click={() => modal.set(false)}
							style="display:inline-block;background-color:#{colour};height:40px;width:40px;" />
					</form>
				{/each}
			</div>
		</div>
	</Modal>
{/if}

<style lang="sass">
	.card 
		background: var(--accent)

	.bodyPart
		border-radius: 3px
	#Head
		border-radius: 12px

	.btn-close
		filter: invert(1) grayscale(100%) brightness(200%)
</style>
