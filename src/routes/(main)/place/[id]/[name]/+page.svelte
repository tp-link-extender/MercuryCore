<script lang="ts">
	import { enhance, deserialize } from "$app/forms"
	import fade from "$lib/fade"
	import Modal from "$lib/components/Modal.svelte"
	import Report from "$lib/components/Report.svelte"
	import customProtocolCheck from "custom-protocol-check"
	import { writable } from "svelte/store"

	export let data
	const user = data.user

	const statistics = [
		["Activity", "0 visits"],
		["Creation", data.created.toLocaleDateString()],
		["Updated", data.updated.toLocaleDateString()],
		["Genre", "Horror"],
		["Server Limit", data.maxPlayers],
		["Now Playing", data.GameSessions.length],
	]

	const images = [
		"/place/placeholderImage1.png",
		"/place/placeholderImage2.png",
		"/place/placeholderImage3.png",
	]

	// Place Launcher

	let modal = writable(false)
	let installed = true
	let success = false
	let filepath = ""

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
		})
		const joinScriptData = deserialize(await response.text())

		if (joinScriptData.status == 200) {
			launch(
				`mercury-player:1+launchmode:play+joinscripturl:${encodeURIComponent(
					joinScriptData.data.joinScriptUrl
				)}+gameinfo:test`
			)
		}
	}
</script>

<svelte:head>
	<title>{data.name} - Mercury</title>
</svelte:head>

<div class="container">
	<div class="row">
		<div in:fade id="carousel" class="carousel slide col-md-8 mb-3">
			<div class="carousel-indicators">
				{#each images as _, i}
					<button
						type="button"
						data-bs-target="#carousel"
						data-bs-slide-to={i}
						aria-label="Slide {i + 1}"
						class:active={!i}
						aria-current={!i} />
				{/each}
			</div>
			<div class="carousel-inner rounded-4">
				{#each images as src, i}
					<div class="carousel-item" class:active={!i}>
						<img {src} class="d-block w-100" alt="..." />
					</div>
				{/each}
			</div>
			<button
				class="carousel-control-prev"
				type="button"
				data-bs-target="#carousel"
				data-bs-slide="prev">
				<span class="carousel-control-prev-icon" aria-hidden="true" />
				<span class="visually-hidden">Previous</span>
			</button>
			<button
				class="carousel-control-next"
				type="button"
				data-bs-target="#carousel"
				data-bs-slide="next">
				<span class="carousel-control-next-icon" aria-hidden="true" />
				<span class="visually-hidden">Next</span>
			</button>
		</div>
		<div class="flex col-md-4">
			<div class="card rounded-none mb-4">
				<div class="card-body">
					<div class="row">
						<div class="col">
							<h2 class="light-text">{data.name}</h2>
						</div>
						{#if data.ownerUser?.number == user?.number || user?.permissionLevel >= 4}
							<div
								id="settings"
								class="col d-flex justify-content-end">
								<a
									href="/place/{data.id}/{data.name}/settings"
									class="btn btn-sm btn-outline-warning">
									<i class="fas fa-sliders" />
								</a>
							</div>
						{/if}
					</div>
					<p class="light-text mt-2 mb-0">
						<b>By</b>
						<a
							href="/user/{data.ownerUser?.number}"
							class="text-decoration-none">
							{data.ownerUser?.username}
						</a>
					</p>
					<p class="light-text mb-0">
						Gears: <i
							class="far fa-circle-xmark"
							data-bs-toggle="tooltip"
							data-bs-placement="bottom"
							data-bs-title="Tooltip on top" />
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
						<Report
							user={data.ownerUser?.username || ""}
							url="/place/{data.id}/{data.name}" />
					</span>
				</div>
			</div>
			<div id="buttons" class="row">
				<button
					on:click={placeLauncher}
					id="play"
					class="btn btn-lg btn-success mt-4 {data.serverPing >
					Date.now() / 1000 - 35
						? ''
						: 'disabled'}">
					<img src="/place/join.svg" alt="Play button icon" />
				</button>

				<form
					use:enhance
					class="align-self-center col mt-3 px-0 mb-2"
					method="POST"
					action="?/like">
					<input
						type="hidden"
						name="privateTicket"
						value={data.privateTicket} />
					<div class="row mb-2">
						<div class="col d-flex justify-content-start">
							<button
								name="action"
								value={data.likes ? "unlike" : "like"}
								class="btn btn-sm {data.likes
									? 'btn-success'
									: 'btn-outline-success'}">
								{#if data.likes}
									<i class="fa fa-thumbs-up" />
								{:else}
									<i class="far fa-thumbs-up" />
								{/if}
							</button>
						</div>
						<div class="col d-flex justify-content-end">
							<button
								name="action"
								value={data.dislikes ? "undislike" : "dislike"}
								class="btn btn-sm {data.dislikes
									? 'btn-danger'
									: 'btn-outline-danger'}">
								{#if data.dislikes}
									<i class="fa fa-thumbs-down" />
								{:else}
									<i class="far fa-thumbs-down" />
								{/if}
							</button>
						</div>
					</div>
					<div class="progress rounded-pill" style="height: 3px">
						<div
							class="progress-bar bg-success"
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
							class="progress-bar bg-danger"
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
					<div class="row">
						<div class="col d-flex justify-content-start">
							<span class="light-text mx-2">
								{data.likeCount} like{data.likeCount == 1
									? ""
									: "s"}
							</span>
						</div>
						<div class="col d-flex justify-content-end">
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
	<ul class="nav nav-pills nav-justified mb-3 bg-a" id="pills-tab">
		<li class="nav-item" role="presentation">
			<button
				class="nav-link active"
				id="pills-desc-tab"
				data-bs-toggle="pill"
				data-bs-target="#pills-desc"
				type="button"
				role="tab"
				aria-controls="pills-desc"
				aria-selected="true">
				Description
			</button>
		</li>
		<li class="nav-item" role="presentation">
			<button
				class="nav-link"
				id="pills-game-tab"
				data-bs-toggle="pill"
				data-bs-target="#pills-game"
				type="button"
				role="tab"
				aria-controls="pills-game"
				aria-selected="false">
				Game
			</button>
		</li>
	</ul>
	<div class="tab-content" id="pills-tabContent">
		<div
			class="tab-pane fade show active"
			id="pills-desc"
			role="tabpanel"
			aria-labelledby="pills-desc-tab"
			tabindex={0}>
			<p class="light-text">
				{data.description[0]?.text || ""}
			</p>
		</div>
		<div
			class="tab-pane fade"
			id="pills-game"
			role="tabpanel"
			aria-labelledby="pills-game-tab"
			tabindex={0}>
			{#if user?.permissionLevel == 5 || data.ownerUser?.number == user?.number}
				<h1 class="h4 light-text">Hosting on Mercury</h1>
				<p class="light-text">
					To begin hosting your map for everybody to play, you need to
					make sure that you are forwarding the port you wish to run
					the server on. If you are unsure on how to host, there are
					many resources available online on how to port forward on
					your router.
				</p>
				<p class="light-text">
					If you have port forwarded already, it's time to get your
					server running. Below are two methods of hosting - we
					recommend using Autopilot to get started easily.
				</p>
				<div class="d-flex align-items-start mb-3">
					<div
						class="nav flex-column nav-pills nav-vert-pills me-3 bg-a"
						id="v-pills-tab"
						role="tablist"
						aria-orientation="vertical">
						<button
							class="nav-link active"
							id="v-pills-manual-tab"
							data-bs-toggle="pill"
							data-bs-target="#v-pills-manual"
							type="button"
							role="tab"
							aria-controls="v-pills-manual"
							aria-selected="true">
							Manual
						</button>
						<button
							class="nav-link"
							id="v-pills-autopilot-tab"
							data-bs-toggle="pill"
							data-bs-target="#v-pills-autopilot"
							type="button"
							role="tab"
							aria-controls="v-pills-autopilot"
							aria-selected="false">
							Autopilot
						</button>
					</div>
					<div class="tab-content" id="v-pills-tabContent">
						<div
							class="tab-pane fade show active"
							id="v-pills-manual"
							role="tabpanel"
							aria-labelledby="v-pills-manual-tab"
							tabindex="0">
							<p class="light-text mb-1">
								You can host your server by opening your map in <button
									class="btn btn-primary p-1 btn-sm"
									on:click={() => {
										launch(
											"mercury-player:1+launchmode:ide"
										)
									}}>
									<i
										class="fas fa-arrow-up-right-from-square" />
									Studio
								</button>
								and then in the command bar, paste this in:
							</p>
							<code>
								loadfile("http://banland.xyz/Game/Host?ticket={data.serverTicket}")()
							</code>
						</div>
						<div
							class="tab-pane fade"
							id="v-pills-autopilot"
							role="tabpanel"
							aria-labelledby="v-pills-autopilot-tab"
							tabindex="0">
							<p class="light-text">
								Autopilot manages initial Studio operations. All
								you need to do is type in a map that's in the
								map folder, and start the server.
							</p>
							<p class="light-text">
								Place your maps in Mercury Studio's maps folder.
								For example, entering <code>CoolMap.rbxl</code>
								will point to
								<code>content\maps\CoolMap.rbxl</code>
								.
							</p>
							<div class="input-group">
								<input
									type="text"
									class="form-control valid"
									id="filepath"
									bind:value={filepath}
									placeholder="Map location"
									aria-label="Map location" />
								<button
									class="btn btn-primary"
									on:click={() => {
										launch(
											"mercury-player:1+launchmode:maps"
										)
									}}
									type="button">
									<i
										class="fas fa-arrow-up-right-from-square" />
									Map Folder
								</button>
								<button
									class="btn btn-success"
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
								<button
									class="btn btn-success dropdown-toggle"
									type="button"
									data-bs-toggle="dropdown"
									aria-expanded="false" />
								<ul class="dropdown-menu dropdown-menu-end">
									<li>
										<button
											class="dropdown-item light-text"
											on:click={() => {
												launch(
													`mercury-player:1+launchmode:build+script:http://banland.xyz/Game/Host?ticket=${
														data.serverTicket
													}&autopilot=${btoa(
														filepath
													)}`
												)
											}}
											type="button">
											Begin Hosting (no Studio tools)
										</button>
									</li>
								</ul>
							</div>
						</div>
					</div>
				</div>
			{/if}
			<h4 class="light-text">Server List</h4>
			<div class="card mb-2">
				<div class="card-body">
					<div class="row">
						<div class="col col-2">
							<p class="light-text mb-2">
								Currently Playing: {data.GameSessions
									.length}/{data.maxPlayers}
							</p>
							<button
								on:click={placeLauncher}
								id="join"
								class="btn btn-sm btn-success">
								Join Server
							</button>
						</div>
						<div class="col">
							{#each data.GameSessions as { user }}
								<a
									href="/user/{user.number}"
									class="text-decoration-none">
									<img
										src={user.image}
										alt={user.username}
										height="75"
										width="75"
										class="pfp bg-background rounded-circle img-fluid rounded-top-0 m-1" />
								</a>
							{/each}
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<hr />
	<div class="row">
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
	<div class="modal-body d-flex flex-column p-4">
		{#key installed}
			<div
				in:fade={{ duration: 500 }}
				id="wrapper"
				class="text-center align-self-center mt-5 mb-4">
				<img
					src="/innerlogo.svg"
					alt="Mercury logo inner part (M)"
					width="128"
					height="128" />
				<img
					src="/outerlogo.svg"
					alt="Mercury logo outer part (circle around M)"
					id="outer"
					width="128"
					height="128"
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
			<h1 class="text-center h5 light-text mb-3">
				Install the Mercury client and start playing now!
			</h1>
			<a
				class="btn btn-success"
				href="https://setup.banland.xyz/MercuryPlayerLauncher.exe">
				Download 2013
			</a>
		{/if}
	</div>
</Modal>

<style lang="sass">
	:target
		display: block !important

	@media only screen and (min-width: 576px)
		.container
			width: 60rem

	#buttons
		margin: auto
		display: flex
		flex-direction: column

	#play img
		height: 2rem

	#settings
		position: absolute
		margin: 3px 0px 0px -10px

	.dropdown-menu
		border-color: var(--accent2)
		z-index: 5

	#wrapper
		width: 128px
		height: 128px
		transform: translateX(-64px)
		img
			box-sizing: border-box
			position: absolute

	#outer
		transform: rotate(0)
		animation: moon 1.5s 0s infinite linear

	@keyframes moon
		100%
			transform: rotate(360deg)

	.nav-link
		border-radius: 0
		color: var(--light-text)

	#pills-tab .active, #v-pills-tab .active
		background: transparent
		border-style: solid
		border-width: 0px 0px 2px 0px
		border-color: var(--bs-blue)
</style>
