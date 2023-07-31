<script lang="ts">
	export let data
	export let form
	const { user } = data

	let modal = writable(false)
	let bodyPart = ""
	let tabData = TabData(data.url, [
		"Recent",
		"Heads",
		"Faces",
		"T-Shirts",
		"Shirts",
		"Pants",
		"Gear",
	])

	const bodyParts: { [k: string]: number } = {
		Head: user?.bodyColours.Head,
		Torso: user?.bodyColours.Torso,
		LeftArm: user?.bodyColours.LeftArm,
		RightArm: user?.bodyColours.RightArm,
		LeftLeg: user?.bodyColours.LeftLeg,
		RightLeg: user?.bodyColours.RightLeg,
	}

	const bodyColours = [
		1024, 11, 102, 23, 1010, 1012, 1011, 1027, 1018, 151, 1022, 135, 1019,
		1013, 107, 1028, 29, 119, 37, 1021, 1020, 28, 141, 1029, 226, 1008, 24,
		1017, 1009, 105, 1025, 125, 101, 1007, 1016, 1032, 1004, 21, 9, 1026,
		1006, 153, 1023, 1015, 1031, 104, 5, 1030, 18, 106, 38, 1014, 217, 192,
		1001, 1, 208, 1002, 194, 199, 26, 1003,
	]

	const brickToHex: { [k: number]: string } = {
		1: "F2F3F3",
		5: "D7C59A",
		9: "E8BAC8",
		11: "80BBDC",
		18: "CC8E69",
		21: "C4281C",
		23: "0D69AC",
		24: "F5CD30",
		26: "1B2A35",
		28: "287F47",
		29: "A1C48C",
		37: "4B974B",
		38: "A05F35",
		101: "DA867A",
		102: "6E99CA",
		104: "6B327C",
		105: "E29B40",
		106: "DA8541",
		107: "008F9C",
		119: "A4BD47",
		125: "EAB892",
		135: "74869D",
		141: "27462D",
		151: "789082",
		153: "957977",
		192: "694028",
		194: "A3A2A5",
		199: "635F62",
		208: "E5E4DF",
		217: "7C5C46",
		226: "FDEA8D",
		1001: "F8F8F8",
		1002: "CDCDCD",
		1003: "111111",
		1004: "FF0000",
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

	const styles: { [k: string]: string } = {
		Head: `left: 68px; height: 3rem; width: 3rem`,
		Torso: `left: 3rem; top: 54px; height: 88px; width: 88px`,
		LeftArm: `left: 1px; top: 54px; height: 88px; width: 40px`,
		RightArm: `left: 142px; top: 54px; height: 88px; width: 40px`,
		LeftLeg: `left: 3rem; top: 148px; height: 88px; width: 40px`,
		RightLeg: `left: 96px; top: 148px; height: 88px; width: 40px`,
	}

	const openColorPicker = (bodypart: string) => () => {
		modal.set(true)
		bodyPart = bodypart
	}
</script>

<div class="container">
	<h1 class="text-white">Avatar</h1>
	<p class="light-text">Avatar system in alpha.</p>
	<div class="row mt-4">
		<div class="col-xl-3 col-lg-3 col-md-6 col-sm-12">
			<div class="card mb-3">
				<div class="card-body">
					<form use:enhance action="?/regen" method="POST">
						<button class="btn btn-primary w-100">
							<i class="fa fa-rotate" />
							Regenerate
						</button>
					</form>
					<p class="text-danger">
						{form?.msg || ""}
					</p>
					<img
						alt="Your avatar"
						class="w-100"
						src={form?.avatar ||
							`/api/avatar/${
								user.username
							}-body?r=${Math.random()}`} />
				</div>
			</div>
			<div class="card">
				<div class="card-header light-text">Body Colours</div>
				<div class="card-body">
					<div class="mannequin text-center">
						<div
							class="mx-auto"
							style="height:240px;width:194px;text-align:center;">
							<div class="parts">
								{#each Object.keys(bodyParts) as bodyPart}
									<button
										style={styles[bodyPart] +
											`;background-color: #${
												brickToHex[bodyParts[bodyPart]]
											};`}
										class="btn p-0 bodyPart position-absolute"
										on:click={openColorPicker(bodyPart)}
										on:keydown={openColorPicker(
											bodyPart,
										)} />
								{/each}
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="col-xl-9 col-lg-9 col-md-12">
			<TabNav bind:tabData justify />
			<!-- <div class="input-group">
				<input
					type="text"
					name="query"
					class="form-control light-text valid"
					placeholder="Search for an item"
					aria-label="Search for an item"
					aria-describedby="button-addon2" />
				<button
					class="btn btn-success"
					aria-label="Search"
					id="button-addon2">
					<i class="fa fa-magnifying-glass" />
				</button>
			</div> -->
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
		<div class="modal-body d-flex flex-column p-1 pb-5">
			<div id="colourPicker" class="text-left mx-auto">
				{#each bodyColours as colour}
					<form
						use:enhance
						method="POST"
						action="?/paint&p={bodyPart}&c={colour}"
						on:submit={() => {
							bodyParts[bodyPart] = colour
							modal.set(false)
						}}
						class="d-inline">
						<button
							class="btn colour my-1"
							style="background-color: #{brickToHex[colour]};" />
					</form>
				{/each}
			</div>
		</div>
	</Modal>
{/if}

<style lang="stylus">
	.card
		background var(--accent)

	.bodyPart
		border-radius 3px
		&:first-child // Head
			border-radius 12px

	.colour
		margin-left 2px
		margin-right 2px
		transition filter 0.2s ease-out
		&:hover
			filter brightness(50%)

	#colourPicker
		max-width 27rem

	button.colour
		height 2.5rem
		width 2.5rem

	img
		aspect-ratio 3/4 !important

	.btn-close
		filter invert(1) grayscale(100%) brightness(200%)

	.parts
		position relative
		margin 11px 0px 0px 36px

		+-sm()
			position relative
			margin 11px 4px 0px 7px

		+sm()
			position relative
			margin 11px 4px 0px 7px

		+md()
			position relative
			margin 11px 4px 0px 9px

		+lg()
			position relative
			margin 11px 4px 0px -8px

		+xl()
			position relative
			margin 11px 0px 0px 7px
</style>
