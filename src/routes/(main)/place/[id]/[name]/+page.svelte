<script lang="ts">
	import customProtocolCheck from "custom-protocol-check"
	import Autopilot from "./Autopilot.svelte"

	export let data
	const { user } = data

	$: online = data.serverPing > Date.now() / 1000 - 35

	const statistics = [
		["Activity", "0 visits"],
		["Creation", new Date(data.created).toLocaleDateString()],
		["Updated", new Date(data.updated).toLocaleDateString()],
		["Genre", "Horror"],
		["Server Limit", data.maxPlayers],
		["Now Playing", data.players.length]
	]
	const images = [
		"/place/placeholderImage1.webp",
		"/place/placeholderImage2.webp",
		"/place/placeholderImage3.webp"
	]
	const scroll = (e: MouseEvent) =>
		document
			.getElementById(
				new URL((e.target as HTMLAnchorElement)?.href).hash.slice(1)
			)
			// (false) prevents page scrolling to top of element
			?.scrollIntoView(false)

	// Place Launcher

	const modal = writable(false)
	let installed = true
	let success = false

	const launch = (joinscripturl: string) => () => {
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

	const hostTicket = `http://banland.xyz/game/host?ticket=${data.serverTicket}`

	async function placeLauncher() {
		installed = true
		modal.set(true)

		const formdata = new FormData()

		formdata.append("request", "RequestGame")
		formdata.append("serverId", data.id.toString())
		formdata.append("privateTicket", data.privateTicket)

		const response = await fetch(`/place/${data.id}/${data.name}?/join`, {
			method: "POST",
			body: formdata
		})
		const joinScriptData = deserialize(await response.text()) as {
			status: number
			data: {
				joinScriptUrl: string
			}
		}

		if (joinScriptData.status === 200)
			launch(
				`mercury-player:1+launchmode:play+joinscripturl:${encodeURIComponent(
					joinScriptData.data.joinScriptUrl
				)}+gameinfo:test`
			)()
	}

	let tabData = TabData(data.url, ["Description", "Game"])
	let tabData2 = TabData(data.url, ["Manual", "Autopilot"], undefined, "tab2")
</script>

<Head title={data.name} />

<div class="ctnr max-w-240 light-text">
	<div class="grid grid-cols-1 md:(grid-cols-3 gap-4)">
		<div class="col-span-2 pb-4">
			<div in:fade class="carousel rounded-4">
				{#each images as src, i}
					<div
						id="slide{i + 1}"
						class="carousel-item relative w-full"
						class:active={!i}>
						<img
							{src}
							class="w-full"
							alt="Placeholder place thumbnail" />
						<div
							class="absolute flex justify-between top-1/2
							-translate-y-1/2 left-4 right-4">
							<a
								href="#slide{i < 1 ? images.length : i}"
								class="carousel-button"
								on:click|preventDefault={scroll}>
								❮
							</a>
							<a
								href="#slide{i == images.length - 1
									? 1
									: i + 2}"
								class="carousel-button"
								on:click|preventDefault={scroll}>
								❯
							</a>
						</div>
					</div>
				{/each}
			</div>
		</div>

		<div class="flex flex-col justify-between gap-3">
			<div class="card bg-darker p-4 pb-6 block">
				<div class="flex justify-between">
					<h1 class="text-2xl">{data.name}</h1>
					{#if data.ownerUser?.number == user?.number || user?.permissionLevel >= 4}
						<div>
							<a
								aria-label="Place settings"
								href="/place/{data.id}/{data.name}/settings"
								class="btn btn-sm btn-secondary">
								<fa fa-sliders />
							</a>
						</div>
					{/if}
				</div>
				<span class="flex py-2">
					<b class="pr-2">by</b>
					{#if data.ownerUser}
						<User
							user={data.ownerUser}
							size="1.5rem"
							bg="darker"
							full
							thin />
					{/if}
				</span>
				<div>
					Gears: <far fa-circle-xmark />
				</div>
				<small
					class="text-white rounded-2 {online
						? 'bg-emerald-6'
						: 'bg-red-5'} p-2 py-1">
					{online ? "Online" : "Offline"}
				</small>
				<span class="float-right">
					<ReportButton
						user={data.ownerUser?.username || ""}
						url="/place/{data.id}/{data.name}" />
				</span>
			</div>
			<div id="buttons" class="flex flex-col">
				<button on:click={placeLauncher} class="btn btn-primary">
					<img
						src="/place/join.svg"
						alt="Play button icon"
						class="h-8" />
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
					class="w-full pt-4 px-0 pb-2"
					method="POST"
					action="?/like&privateTicket={data.privateTicket}">
					<div class="flex justify-between pb-2">
						<button
							name="action"
							value={data.likes ? "unlike" : "like"}
							aria-label={data.likes ? "Unlike" : "Like"}
							class="btn p-0 px-1 text-emerald-5">
							<i
								class="fa{data.likes
									? ' text-emerald-6 hover:text-emerald-3'
									: 'r text-neutral-5 hover:text-neutral-3'}
								fa-thumbs-up transition text-lg" />
						</button>
						<button
							name="action"
							value={data.dislikes ? "undislike" : "dislike"}
							aria-label={data.dislikes ? "Undislike" : "Dislike"}
							class="btn p-0 px-1 text-red-5">
							<i
								class="fa{data.dislikes
									? ' text-red-5 hover:text-red-3'
									: 'r text-neutral-5 hover:text-neutral-3'}
								fa-thumbs-down transition text-lg" />
						</button>
					</div>
					<div class="flex bg-a2 h-3px">
						<div
							class="bg-emerald-5"
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
							class="bg-red-5"
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
					<div class="flex justify-between">
						<span class="px-2">
							{data.likeCount} like{data.likeCount == 1
								? ""
								: "s"}
						</span>
						<span class="px-2">
							{data.dislikeCount} dislike{data.dislikeCount == 1
								? ""
								: "s"}
						</span>
					</div>
				</form>
			</div>
		</div>
	</div>

	<TabNav bind:tabData justify />

	<Tab {tabData}>
		{data.description.text || ""}
	</Tab>

	<Tab {tabData}>
		{#if user?.permissionLevel == 5 || data.ownerUser?.number == user?.number}
			<h1 class="text-base">Hosting on Mercury</h1>
			<p>
				To begin hosting your map for everybody to play, you need to
				make sure that you are forwarding the port you wish to run the
				server on. If you are unsure on how to host, there are many
				resources available online on how to port forward on your
				router.
			</p>
			<p>
				If you have port forwarded already, it's time to get your server
				running. Below are two methods of hosting - we recommend using
				Autopilot to get started easily.
			</p>
			<div class="flex items-start mb-4">
				<TabNav bind:tabData={tabData2} vertical class="pr-4" />
				<!-- Prevents nested tabs from breaking -->
				{((tabData2.num = 0), "")}
				<Tab tabData={tabData2}>
					<p>
						You can host your server by opening your map in <button
							class="btn btn-sm btn-tertiary"
							on:click={launch(
								"mercury-player:1+launchmode:ide"
							)}>
							<fa fa-arrow-up-right-from-square />
							Studio
						</button>
						and then in the command bar, paste this in:
					</p>
					<code>
						loadfile("{hostTicket}")()
					</code>
				</Tab>
				<Tab tabData={tabData2}>
					<Autopilot {launch} {hostTicket} />
				</Tab>
			</div>
		{/if}
		<h4>Server List</h4>
		{#if online}
			<div class="card p-4 flex flex-row">
				<div class="w-1/6">
					<div class="pb-2">
						Currently Playing: {data.players
							.length}/{data.maxPlayers}
					</div>
					<button
						on:click={placeLauncher}
						id="join"
						class="btn btn-sm btn-primary">
						Join Server
					</button>
				</div>
				<div class="w-5/6 flex gap-3">
					{#each data.players as user}
						<User {user} size="4.5rem" bg="darker" />
					{/each}
				</div>
			</div>
		{:else}
			This server is offline.
		{/if}
	</Tab>
	<hr />
	<div class="flex justify-around">
		{#each statistics as [title, stat]}
			<div>
				<p class="text-center"><b>{title}</b></p>
				<p class="text-center">{stat}</p>
			</div>
		{/each}
	</div>
	<hr />
</div>

<Modal {modal}>
	<div class="flex flex-col px-6 pt-6 text-center">
		{#key installed}
			<div
				in:fade={{ duration: 500 }}
				class="self-center size-32 -translate-x-1/2 @light:invert">
				<img
					src="/innerlogo.svg"
					alt="Mercury logo inner part (M)"
					class="absolute"
					width="128"
					height="128" />
				<img
					src="/outerlogo.svg"
					alt="Mercury logo outer part (circle around M)"
					class="absolute animate-[spin_1.5s_linear_infinite]"
					width="128"
					height="128"
					style={installed
						? ""
						: "animation: none --rotation: 0deg"} />
			</div>
		{/key}
		{#if success}
			<span class="text-xl pt-6">
				"{data.name}" is ready to play! Have fun!
			</span>
		{:else if installed}
			<span class="text-xl pt-6">
				Get ready to join "{data.name}" by {data.ownerUser?.username}!
			</span>
		{:else}
			<span class="text-xl pt-6">
				Install the Mercury client and start playing now!
			</span>
			<a
				class="btn btn-primary"
				href="https://setup.banland.xyz/MercuryPlayerLauncher.exe">
				Download 2013
			</a>
		{/if}
	</div>
</Modal>
