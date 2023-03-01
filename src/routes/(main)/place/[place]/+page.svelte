<script lang="ts">
	import type { PageData } from "./$types"
	import { enhance, deserialize } from "$app/forms"
	import { getUser } from "@lucia-auth/sveltekit/client"
	import fade from "$lib/fade"
	import { onMount } from "svelte"
	import { Modal } from "bootstrap"
	import customProtocolCheck from "custom-protocol-check"


	export let data: PageData

	const statistics = [
		["Activity", "8 visits"],
		["Creation", data.created.toLocaleDateString()],
		["Updated", "Three hours ago"],
		["Genre", "Horror"],
		["Server Limit", data.maxPlayers],
		["Now Playing", "0 players"],
	]

	const images = ["/place/placeholderImage1.png", "/place/placeholderImage2.png", "/place/placeholderImage3.png"]

	const user = getUser()

	// Place Launcher

	let modal: any

	let installed = true
	let success = false

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
		modal.show()

		const formdata = new FormData()

		formdata.append("request", "RequestGame")
		formdata.append("serverID", data.id)

		const response = await fetch(`/place/${data.slug}?/join`, { method: "POST", body: formdata })
		const joinScriptData = deserialize(await response.text())

		if(joinScriptData.status == 200) {
			launch(`mercury-player:1+launchmode:play+joinscripturl:${encodeURIComponent(joinScriptData.data.joinScriptUrl)}`)
		}
	}

	onMount(() => {
		modal = new Modal("#placeLauncherModal", {
			keyboard: false,
		})

		modal.hide()
	}) 
</script>

<svelte:head>
	<title>{data.name} - Mercury</title>
</svelte:head>

<div class="container">
	<div class="row">
		<div in:fade id="carousel" class="carousel slide col-md-8 mb-3">
			<div class="carousel-indicators">
				{#each images as _, i}
					<button type="button" data-bs-target="#carousel" data-bs-slide-to={i} aria-label="Slide {i + 1}" class:active={!i} aria-current={!i} />
				{/each}
			</div>
			<div class="carousel-inner rounded-4">
				{#each images as src, i}
					<div class="carousel-item" class:active={!i}>
						<img {src} class="d-block w-100" alt="..." />
					</div>
				{/each}
			</div>
			<button class="carousel-control-prev" type="button" data-bs-target="#carousel" data-bs-slide="prev">
				<span class="carousel-control-prev-icon" aria-hidden="true" />
				<span class="visually-hidden">Previous</span>
			</button>
			<button class="carousel-control-next" type="button" data-bs-target="#carousel" data-bs-slide="next">
				<span class="carousel-control-next-icon" aria-hidden="true" />
				<span class="visually-hidden">Next</span>
			</button>
		</div>
		<div class="flex col-md-4">
			<div class="card rounded-none mb-4">
				<div class="card-body">
					<h2 class="light-text">{data.name}</h2>
					<p class="light-text mt-2 mb-0">
						<b>By</b> <a href="/user/{data.owner?.number}" class="text-decoration-none">{data.owner?.displayname}</a>
					</p>
					<p class="light-text mb-0">Gears: <i class="fa-regular fa-circle-xmark" data-bs-toggle="tooltip" data-bs-placement="bottom" data-bs-title="Tooltip on top" /></p>
					<span class="badge text-bg-success mb-1">Online</span>
				</div>
			</div>
			<div id="buttons" class="row">
				<a on:click={placeLauncher} href="mercury-player:1+launchmode:ide" id="play" class="btn btn-lg btn-success mt-4">
					<img src="/place/join.svg" alt="Play button icon" />
				</a>
				<form use:enhance class="align-self-center col mt-3 px-0 mb-2" method="POST" action="?/like">
					<div class="row mb-2">
						<div class="col d-flex justify-content-start">
							<button name="action" value={data.likes ? "unlike" : "like"} class="btn btn-sm {data.likes ? 'btn-success' : 'btn-outline-success'}">
								{#if data.likes}
									<i class="fa fa-thumbs-up" />
								{:else}
									<i class="fa-regular fa-thumbs-up" />
								{/if}
							</button>
						</div>
						<div class="col d-flex justify-content-end">
							<button name="action" value={data.dislikes ? "undislike" : "dislike"} class="btn btn-sm {data.dislikes ? 'btn-danger' : 'btn-outline-danger'}">
								{#if data.dislikes}
									<i class="fa fa-thumbs-down" />
								{:else}
									<i class="fa-regular fa-thumbs-down" />
								{/if}
							</button>
						</div>
					</div>
					<div class="progress rounded-pill" style="height: 3px">
						<div
							class="progress-bar bg-success"
							role="progressbar"
							aria-label="Likes"
							style="width: {(data.likeCount / (data.dislikeCount + data.likeCount || 1)) * 100}%"
							aria-valuenow={data.likeCount}
							aria-valuemin={0}
							aria-valuemax={data.dislikeCount + data.likeCount}
						/>
						<div
							class="progress-bar bg-danger"
							role="progressbar"
							aria-label="Dislikes"
							style="width: {(data.dislikeCount / (data.dislikeCount + data.likeCount || 1)) * 100}%"
							aria-valuenow={data.dislikeCount}
							aria-valuemin={0}
							aria-valuemax={data.dislikeCount + data.likeCount}
						/>
					</div>
					<div class="row">
						<div class="col d-flex justify-content-start">
							<span class="light-text mx-2">
								{data.likeCount} like{data.likeCount == 1 ? "" : "s"}
							</span>
						</div>
						<div class="col d-flex justify-content-end">
							<span class="light-text mx-2">
								{data.dislikeCount} dislike{data.dislikeCount == 1 ? "" : "s"}
							</span>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
	<ul class="nav nav-pills nav-justified mb-3" id="pills-tab" role="tablist">
		<li class="nav-item" role="presentation">
			<button class="nav-link active" id="pills-desc-tab" data-bs-toggle="pill" data-bs-target="#pills-desc" type="button" role="tab" aria-controls="pills-desc" aria-selected="true"
				>Description</button
			>
		</li>
		<li class="nav-item" role="presentation">
			<button class="nav-link" id="pills-game-tab" data-bs-toggle="pill" data-bs-target="#pills-game" type="button" role="tab" aria-controls="pills-game" aria-selected="false">Game</button>
		</li>
	</ul>
	<div class="tab-content" id="pills-tabContent">
		<div class="tab-pane fade show active" id="pills-desc" role="tabpanel" aria-labelledby="pills-desc-tab" tabindex={0}>
			<p class="light-text">
				{data.description}
			</p>
		</div>
		<div class="tab-pane fade" id="pills-game" role="tabpanel" aria-labelledby="pills-game-tab" tabindex={0}>
			<h4 class="light-text">Server List</h4>
			<div class="card mb-2">
				<div class="card-body">
					<div class="row">
						<div class="col col-2">
							<p class="light-text mb-2">Currently Playing: 0/{data.maxPlayers}</p>
							<a on:click={placeLauncher} href="mercury-player:1+launchmode:ide" id="join" class="btn btn-sm btn-success">Join Server</a>
						</div>
						<div class="col">
							<img src={$user?.image} id="pfp" alt="You" height="75" width="75" class="rounded-circle img-fluid rounded-top-0 ml-2" />
							<img src={$user?.image} id="pfp" alt="You" height="75" width="75" class="rounded-circle img-fluid rounded-top-0 ml-2" />
							<img src={$user?.image} id="pfp" alt="You" height="75" width="75" class="rounded-circle img-fluid rounded-top-0 ml-2" />
							<img src={$user?.image} id="pfp" alt="You" height="75" width="75" class="rounded-circle img-fluid rounded-top-0 ml-2" />
							<img src={$user?.image} id="pfp" alt="You" height="75" width="75" class="rounded-circle img-fluid rounded-top-0 ml-2" />
							<img src={$user?.image} id="pfp" alt="You" height="75" width="75" class="rounded-circle img-fluid rounded-top-0 ml-2" />
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
<div class="modal fade" id="placeLauncherModal" tabindex="-1" aria-labelledby="placeLauncherModal" aria-modal="true" role="dialog">
	<div class="modal-dialog modal-dialog-centered">
		<div class="modal-content">
			<div class="modal-body d-flex flex-column p-4" in:fade>
				{#key installed}
					<div in:fade={{ duration: 500 }} id="wrapper" class="text-center align-self-center mt-5 mb-4">
						<img src="/innerlogo.svg" alt="Mercury logo inner part (M)" width="128" height="128" />
						<img src="/outerlogo.svg" alt="Mercury logo outer part (circle around M)" id="outer" width="128" height="128" style={installed ? "" : "animation: none; --rotation: 0deg"} />
					</div>
				{/key}
				{#if installed}
					<h1 class="text-center h5 light-text">Get ready to join "{data.name}" by {data.owner?.displayname}!</h1>
				{:else if success}
					<h1 class="text-center h5 light-text">"{data.name}" is ready to play! Have fun!</h1>
				{:else}
					<h1 class="text-center h5 light-text mb-3">Install the Mercury client and start playing now!</h1>
					<a class="btn btn-success" href="https://setup.banland.xyz/MercuryPlayerLauncher.exe">Download 2013</a>
				{/if}
			</div>
		</div>
	</div>
</div>

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

	.card
		background: var(--accent)

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

	.nav-pills
		background: var(--accent)
		// border-radius: 1rem 1rem 0 0

		.active
			background: transparent
			border-style: solid
			border-width: 0px 0px 2px 0px
			border-color: var(--bs-blue)

	.modal-content
		background: var(--background)
		border-color: var(--accent)

	#pfp
		background: var(--background)
</style>
