<script lang="ts">
	import customProtocolCheck from "custom-protocol-check"

	export let data
	const { user } = data,
		statistics = [
			["Activity", "0 visits"],
			["Creation", data.created.toLocaleDateString()],
			["Updated", data.updated.toLocaleDateString()],
			["Genre", "Horror"],
			["Server Limit", data.maxPlayers],
			["Now Playing", data.gameSessions.length],
		],
		images = [
			"/place/placeholderImage1.webp",
			"/place/placeholderImage2.webp",
			"/place/placeholderImage3.webp",
		],
		scroll = async (e: MouseEvent) =>
			document
				.getElementById(
					new URL((e.target as HTMLAnchorElement)?.href).hash.slice(1)
				)
				// (false) prevents page scrolling to top of element
				?.scrollIntoView(false)

	// Place Launcher

	let modal = writable(false),
		installed = true,
		success = false,
		filepath = ""

	function launch(joinscripturl: string) {
		success = false
		customProtocolCheck(
			joinscripturl,
			() => {
				installed = false
				console.log("URI not found.")
			},
			() => {
				success = true
				console.log("URI found, launching")
				setTimeout(() => modal.set(false), 16000)
			},
			5000
		)
	}

	async function placeLauncher() {
		installed = true
		modal.set(true)

		const formdata = new FormData()

		formdata.append("request", "RequestGame")
		formdata.append("serverId", data.id.toString())
		formdata.append("privateTicket", data.privateTicket)

		const response = await fetch(`/place/${data.id}/${data.name}?/join`, {
				method: "POST",
				body: formdata,
			}),
			joinScriptData: any = deserialize(await response.text())

		if (joinScriptData.status == 200)
			launch(
				`mercury-player:1+launchmode:play+joinscripturl:${encodeURIComponent(
					joinScriptData.data.joinScriptUrl
				)}+gameinfo:test`
			)
	}

	let tabData = TabData(data.url, ["Description", "Game"]),
		tabData2 = TabData(data.url, ["Manual", "Autopilot"], undefined, "tab2")
</script>

<Head title={data.name} />

<div class="w-70rem mx-a light-text">
	<div class="row">
		<div class="col-md-8 mb-4">
			<div in:fade class="carousel rounded-4">
				{#each images as src, i}
					<div
						id="slide{i + 1}"
						class="carousel-item position-relative w-100"
						class:active={!i}>
						<img
							{src}
							class="block w-100"
							alt="Placeholder place thumbnail" />
						<div
							class="position-absolute d-flex justify-content-between carouselbuttons">
							<a
								href="#slide{i < 1 ? images.length : i}"
								class="btn rounded-pill bg-background"
								on:click|preventDefault={scroll}>
								❮
							</a>
							<a
								href="#slide{i == images.length - 1
									? 1
									: i + 2}"
								class="btn rounded-pill bg-background"
								on:click|preventDefault={scroll}>
								❯
							</a>
						</div>
					</div>
				{/each}
			</div>
		</div>

		<div class="flex col-md-4">
			<div class="card rounded-none mb-6">
				<div class="card-body">
					<div class="grid grid-cols-12 gap-6">
						<div class="col">
							<h2 class="light-text">{data.name}</h2>
						</div>
						{#if data.ownerUser?.number == user?.number || user?.permissionLevel >= 4}
							<div
								id="settings"
								aria-label="Place settings"
								class="col flex justify-end">
								<a
									href="/place/{data.id}/{data.name}/settings"
									class="btn btn-sm btn-outline-warning">
									<i class="fas fa-sliders" />
								</a>
							</div>
						{/if}
					</div>
					<span class="light-text flex mb-2">
						<b>by</b>
						<a
							href="/user/{data.ownerUser?.number}"
							class="user light-text text-decoration-none">
							<span class="pfp bg-darker rounded-circle ms-1">
								<img
									src="/api/avatar/{data.ownerUser?.username}"
									alt={data.ownerUser?.username}
									class="rounded-full rounded-t-0" />
							</span>
							{data.ownerUser?.username}
						</a>
					</span>
					<p class="light-text mb-0">
						Gears: <i class="far fa-circle-xmark" />
					</p>
					<span
						class="badge text-bg-{data.serverPing >
						Math.floor(Date.now() / 1000) - 35
							? 'success'
							: 'danger'} mb-1">
						{data.serverPing > Date.now() / 1000 - 35
							? "Online"
							: "Offline"}
					</span>
					<span class="float-end">
						<ReportButton
							user={data.ownerUser?.username || ""}
							url="/place/{data.id}/{data.name}" />
					</span>
				</div>
			</div>
			<div id="buttons" class="grid grid-cols-12 gap-6">
				<button
					on:click={placeLauncher}
					id="play"
					class:disabled={data.serverPing < Date.now() / 1000 - 35}
					class="btn btn-lg btn-success mt-6">
					<img src="/place/join.svg" alt="Play button icon" />
				</button>

				<form
					use:enhance={({ formData }) => {
						const action = formData.get("action")

						if (action == "like") {
							data.likes = true

							if (data.dislikes) data.dislikeCount--
							data.dislikes = false
							data.likeCount++
						} else if (action == "dislike") {
							data.dislikes = true

							if (data.likes) data.likeCount--
							data.likes = false
							data.dislikeCount++
						} else if (action == "unlike") {
							data.likes = false
							data.likeCount--
						} else if (action == "undislike") {
							data.dislikes = false
							data.dislikeCount--
						}

						return () => {}
					}}
					class="align-self-center col mt-4 px-0 mb-2"
					method="POST"
					action="?/like&privateTicket={data.privateTicket}">
					<div class="row mb-2">
						<div class="col d-flex justify-content-start">
							<button
								name="action"
								value={data.likes ? "unlike" : "like"}
								aria-label={data.likes ? "Unlike" : "Like"}
								class="btn btn-sm btn-{data.likes
									? ''
									: 'outline-'}success">
								<i
									class="fa{data.likes
										? ''
										: 'r'} fa-thumbs-up" />
							</button>
						</div>
						<div class="col flex justify-end">
							<button
								name="action"
								value={data.dislikes ? "undislike" : "dislike"}
								aria-label={data.dislikes
									? "Undislike"
									: "Dislike"}
								class="btn btn-sm btn-{data.dislikes
									? ''
									: 'outline-'}danger">
								<i
									class="fa{data.dislikes
										? ''
										: 'r'} fa-thumbs-down" />
							</button>
						</div>
					</div>
					<div class="progress rounded-pill" style="height: 3px">
						<div
							class="progress-bar bg-emerald-500"
							role="progressbar"
							aria-label="Likes"
							style="width: {(data.likeCount /
								(data.dislikeCount + data.likeCount || 1)) *
								100}%"
							aria-valuenow={data.likeCount}
							aria-valuemin={0}
							aria-valuemax={data.dislikeCount +
								data.likeCount} />
						<div
							class="progress-bar bg-red-500"
							role="progressbar"
							aria-label="Dislikes"
							style="width: {(data.dislikeCount /
								(data.dislikeCount + data.likeCount || 1)) *
								100}%"
							aria-valuenow={data.dislikeCount}
							aria-valuemin={0}
							aria-valuemax={data.dislikeCount +
								data.likeCount} />
					</div>
					<div class="grid grid-cols-12 gap-6">
						<div class="col flex justify-start">
							<span class="light-text mx-2">
								{data.likeCount} like{data.likeCount == 1
									? ""
									: "s"}
							</span>
						</div>
						<div class="col flex justify-end">
							<span class="light-text mx-2">
								{data.dislikeCount} dislike{data.dislikeCount ==
								1
									? ""
									: "s"}
							</span>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>

	<div class="bg-a">
		<TabNav bind:tabData justify />
	</div>

	<Tab {tabData}>
		{data.description[0]?.text || ""}
	</Tab>

	<Tab {tabData}>
		{#if user?.permissionLevel == 5 || data.ownerUser?.number == user?.number}
			<h1 class="h4 light-text">Hosting on Mercury</h1>
			<p class="light-text">
				To begin hosting your map for everybody to play, you need to
				make sure that you are forwarding the port you wish to run the
				server on. If you are unsure on how to host, there are many
				resources available online on how to port forward on your
				router.
			</p>
			<p class="light-text">
				If you have port forwarded already, it's time to get your server
				running. Below are two methods of hosting - we recommend using
				Autopilot to get started easily.
			</p>
			<div class="d-flex align-items-start mb-4">
				<div class="bg-a me-4">
					<TabNav bind:tabData={tabData2} vertical />
					<!-- Prevents nested tabs from breaking -->
					{((tabData2.num = 0), "")}
				</div>
				<Tab tabData={tabData2}>
					<p class="light-text mb-1">
						You can host your server by opening your map in <button
							class="btn bg-blue-600 hover:bg-blue-800 text-white p-1 btn-sm"
							on:click={() => {
								launch("mercury-player:1+launchmode:ide")
							}}>
							<i class="fas fa-arrow-up-right-from-square" />
							Studio
						</button>
						and then in the command bar, paste this in:
					</p>
					<code>
						loadfile("http://banland.xyz/Game/Host?ticket={data.serverTicket}")()
					</code>
				</Tab>
				<Tab tabData={tabData2}>
					<p class="light-text">
						Autopilot manages initial Studio operations. All you
						need to do is type in a map that's in the map folder,
						and start the server.
					</p>
					<p class="light-text">
						Place your maps in Mercury Studio's maps folder. For
						example, entering <code>CoolMap.rbxl</code>
						will point to
						<code>content\maps\CoolMap.rbxl</code>
						.
					</p>
					<div class="flex">
						<input
							type="text"
							class="form-control valid"
							id="filepath"
							bind:value={filepath}
							placeholder="Map location"
							aria-label="Map location" />
						<button
							class="btn bg-blue-600 hover:bg-blue-800 text-white"
							on:click={() => {
								launch("mercury-player:1+launchmode:maps")
							}}
							type="button">
							<i class="fas fa-arrow-up-right-from-square" />
							Map Folder
						</button>
						<button
							class="btn bg-emerald-600 hover:bg-emerald-800 text-white"
							on:click={() => {
								launch(
									`mercury-player:1+launchmode:ide+script:http://banland.xyz/Game/Host?ticket=${
										data.serverTicket
									}&autopilot=${btoa(filepath)}`
								)
							}}
							type="button">
							<i class="fas fa-wifi" />
							Begin Hosting
						</button>

						<div class="dropdown2 dropdown-hover dropdown-end">
							<button
								class="btn btn-success dropdown-toggle"
								type="button" />
							<div class="dropdown-content pt-2">
								<ul class="p-2 rounded-3">
									<li class="rounded-2">
										<button
											class="btn light-text ps-4 pe-0 text-start"
											on:click={() =>
												launch(
													`mercury-player:1+launchmode:build+script:http://banland.xyz/Game/Host?ticket=${
														data.serverTicket
													}&autopilot=${btoa(
														filepath
													)}`
												)}
											type="button">
											Begin Hosting (no Studio tools)
										</button>
									</li>
								</ul>
							</div>
						</div>
					</div>
				</Tab>
			</div>
		{/if}
		<h4 class="light-text">Server List</h4>
		{#if data.serverPing > Date.now() / 1000 - 35}
			<div class="card mb-2">
				<div class="card-body">
					<div class="row">
						<div class="col col-2">
							<p class="light-text mb-2">
								Currently Playing: {data.gameSessions
									.length}/{data.maxPlayers}
							</p>
							<button
								on:click={placeLauncher}
								id="join"
								class="btn btn-sm btn-success">
								Join Server
							</button>
						</div>
						<div class="col d-flex">
							{#each data.gameSessions as { user }}
								<a
									href="/user/{user.number}"
									class="gamesession text-decoration-none d-flex">
									<span class="bg-background rounded-circle">
										<img
											src="/api/avatar/{user.username}"
											alt={user.username}
											height="75"
											width="75"
											class="rounded-circle rounded-t-0" />
									</span>
								</a>
							{/each}
						</div>
					</div>
				</div>
			</div>
		{:else}
			This server is offline.
		{/if}
	</Tab>
	<hr />
	<div class="grid grid-cols-12 gap-6">
		{#each statistics as [title, stat]}
			<div class="col">
				<p class="light-text text-center"><b>{title}</b></p>
				<p class="light-text text-center">{stat}</p>
			</div>
		{/each}
	</div>
	<hr />
</div>

<Modal {modal}>
	<div class="modal-body d-flex flex-column p-6">
		{#key installed}
			<div
				in:fade={{ duration: 500 }}
				id="wrapper"
				class="text-center align-self-center mt-12 mb-6">
				<img
					src="/innerlogo.svg"
					alt="Mercury logo inner part (M)"
					width={128}
					height={128} />
				<img
					src="/outerlogo.svg"
					alt="Mercury logo outer part (circle around M)"
					id="outer"
					width={128}
					height={128}
					style={installed
						? ""
						: "animation: none; --rotation: 0deg"} />
			</div>
		{/key}
		{#if success}
			<h1 class="text-center h5 light-text">
				"{data.name}" is ready to play! Have fun!
			</h1>
		{:else if installed}
			<h1 class="text-center h5 light-text">
				Get ready to join "{data.name}" by {data.ownerUser?.username}!
			</h1>
		{:else}
			<h1 class="text-center h5 light-text mb-4">
				Install the Mercury client and start playing now!
			</h1>
			<a
				class="btn bg-emerald-600 hover:bg-emerald-800 text-white"
				href="https://setup.banland.xyz/MercuryPlayerLauncher.exe">
				Download 2013
			</a>
		{/if}
	</div>
</Modal>

<style lang="stylus">
	#buttons
		margin auto
		display flex
		flex-direction column

	.carouselbuttons
		transform translateY(-50%)
		left 1.25rem
		right 1.25rem
		top: 50%

	#play img
		height 2rem

	#settings
		position absolute
		margin 3px 0px 0px -10px

	.dropdown-toggle
		border-radius 0 0.375rem 0.375rem 0

	#wrapper
		width 128px
		height 128px
		transform translateX(-64px)

		+lightTheme()
			filter invert(1)

		img
			box-sizing border-box
			position absolute

	#outer
		transform rotate(0)
		animation moon 1.5s 0s infinite linear

	@keyframes moon
		100%
			transform rotate(360deg)

	.user
		.pfp
		.pfp img
			width 1.5rem
			height 1.5rem

	.gamesession
		span
		img
			width 75px
			height 75px
</style>
