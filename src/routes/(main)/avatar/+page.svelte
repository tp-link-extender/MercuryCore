<script lang="ts">
	export let data, form
	const { user } = data

	let query = "",
		searchedData: typeof data.assets = []

	// Run function whenever query changes
	$: query &&
		(async () => {
			const formdata = new FormData()
			formdata.append("q", query)

			const response = await fetch("/avatar?/search", {
					method: "POST",
					body: formdata,
				}),
				result: any = deserialize(await response.text())

			searchedData = result.data.assets
		})()

	const tabTypes: { [k: string]: number } = {
		Recent: 0,
		Heads: 17,
		Faces: 18,
		"T-Shirts": 2,
		Shirts: 11,
		Pants: 12,
		Gear: 19,
	}
	let tabData = TabData(data.url, Object.keys(tabTypes))

	const bodyParts: { [k: string]: number } = {
		Head: user?.bodyColours.Head,
		Torso: user?.bodyColours.Torso,
		LeftArm: user?.bodyColours.LeftArm,
		RightArm: user?.bodyColours.RightArm,
		LeftLeg: user?.bodyColours.LeftLeg,
		RightLeg: user?.bodyColours.RightLeg,
	}
	const bodyPartModals: { [k: string]: HTMLInputElement } = {}
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

	$: assets = (query ? searchedData : data.assets || []).filter(
		a => a.type == tabTypes[tabData.currentTab]
	)
</script>

<div class="container">
	<h1 class="text-white">Avatar</h1>
	<div class="row mt-6">
		<div class="col-xl-3 col-lg-3 col-md-6 col-sm-12">
			<div class="card mb-4">
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
							`/api/avatar/${user.username}-body`} />
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
									<label
										for={bodyPart}
										style={styles[bodyPart] +
											`;background-color: #${
												brickToHex[bodyParts[bodyPart]]
											};`}
										class="btn p-0 bodyPart position-absolute" />
								{/each}
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="col-xl-9 col-lg-9 col-md-12">
			<TabNav bind:tabData justify />
			<form
				use:enhance
				method="POST"
				action="/search?c=assets"
				class="row mb-4">
				<div class="input-group">
					<input
						bind:value={query}
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
				</div>
			</form>
			<div class="row">
				{#each assets || [] as asset, num}
					<AvatarItem {asset} {num} total={(assets || []).length} />
				{/each}
			</div>
		</div>
	</div>
</div>

{#each Object.keys(bodyParts) as bodyPart}
	<input
		type="checkbox"
		id={bodyPart}
		class="modal-toggle"
		bind:this={bodyPartModals[bodyPart]} />
	<div class="modal2">
		<div class="modal-box d-flex flex-column p-4">
			<h1 class="fs-4 light-text">Choose a {bodyPart} color</h1>
			<div id="colourPicker" class="text-left mx-auto">
				{#each bodyColours as colour}
					<form
						use:enhance
						method="POST"
						action="?/paint&p={bodyPart}&c={colour}"
						on:submit={() => {
							bodyParts[bodyPart] = colour
							bodyPartModals[bodyPart].checked = false
						}}
						class="d-inline">
						<button
							class="btn colour my-1"
							style="background-color: #{brickToHex[colour]};" />
					</form>
				{/each}
			</div>
		</div>
		<label class="modal-backdrop" for={bodyPart}>Close</label>
	</div>
{/each}

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
