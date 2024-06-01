<script lang="ts">
	import customProtocol from "./customprotocol"
	import Autopilot from "./Autopilot.svelte"
	import realtime, { type PlaceResponse } from "$lib/realtime"
	import type { Centrifuge, PublicationContext } from "centrifuge"

	export let data
	const { user } = data

	let place = writable(data.place)

	function onPub(c: PublicationContext) {
		const newData = c.data as PlaceResponse

		if (!$place) return

		$place.likeCount = newData.likeCount
		$place.dislikeCount = newData.dislikeCount
		if (newData.hash !== data.user.realtimeHash) return

		switch (newData.action) {
			case "like":
				$place.likes = true
				$place.dislikes = false
				break
			case "dislike":
				$place.likes = false
				$place.dislikes = true
				break
			case "unlike":
			case "undislike":
				$place.likes = false
				$place.dislikes = false
				break
			default:
		}
	}

	let client: Centrifuge | undefined
	onMount(() => {
		client = realtime(data.user.realtimeToken, `place:${$place.id}`, onPub)
	})
	onDestroy(() => client?.disconnect())

	$: online = $place.serverPing > Date.now() / 1000 - 35

	const statistics = [
		["Activity", "0 visits"],
		["Creation", new Date($place.created).toLocaleDateString()],
		["Updated", new Date($place.updated).toLocaleDateString()],
		["Genre", "Horror"],
		["Server Limit", $place.maxPlayers],
		["Now Playing", $place.players.length]
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
		customProtocol(
			joinscripturl,
			() => {
				success = true
				setTimeout(() => modal.set(false), 16000)
			},
			() => {
				installed = false
			}
		)
	}

	const loadCommand = `LoadLibrary "RbxLoad".Start "${$place.serverTicket}"`

	async function placeLauncher() {
		installed = true
		modal.set(true)

		const formdata = new FormData()

		formdata.append("request", "RequestGame")
		formdata.append("serverId", $place.id.toString())
		formdata.append("privateTicket", $place.privateTicket)

		// Get the joinscript URL
		const response = await fetch(`/place/${$place.id}/${data.slug}?/join`, {
			method: "POST",
			body: formdata
		})
		const joinScriptData = deserialize(await response.text()) as {
			status: number
			data: {
				joinScriptUrl: string
			}
		}

		if (joinScriptData.status !== 200) return

		// JoinScript is my favourite programming language (-i mean scripting language)
		const joinScript = encodeURIComponent(joinScriptData.data.joinScriptUrl)

		launch(
			`mercury-player:1+launchmode:play+joinscripturl:${joinScript}+gameinfo:test`
		)()
	}

	let tabData = TabData(data.url, ["Description", "Game"])
	let tabData2 = TabData(data.url, ["Manual", "Autopilot"], undefined, "tab2")
	let copiedSuccess = false
</script>

<Head title={$place.name} />

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
							class="absolute flex justify-between top-1/2 -translate-y-1/2 left-4 right-4">
							<a
								href="#slide{i < 1 ? images.length : i}"
								class="carousel-button"
								on:click|preventDefault={scroll}>
								❮
							</a>
							<a
								href="#slide{i === images.length - 1
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
					<h1 class="text-2xl">{$place.name}</h1>
					{#if $place.ownerUser?.number === user?.number || user?.permissionLevel >= 4}
						<div>
							<a
								aria-label="Place settings"
								href="/place/{$place.id}/{data.slug}/settings"
								class="btn btn-sm btn-secondary">
								<fa fa-sliders />
							</a>
						</div>
					{/if}
				</div>
				<span class="flex py-2">
					<b class="pr-2">by</b>
					{#if $place.ownerUser}
						<User
							user={$place.ownerUser}
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
						user={$place.ownerUser?.username || ""}
						url="/place/{$place.id}/{data.slug}" />
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

						if (action === "like") {
							$place.likes = true

							if ($place.dislikes) $place.dislikeCount--
							$place.dislikes = false
							$place.likeCount++
						} else if (action === "dislike") {
							$place.dislikes = true

							if ($place.likes) $place.likeCount--
							$place.likes = false
							$place.dislikeCount++
						} else if (action === "unlike") {
							$place.likes = false
							$place.likeCount--
						} else if (action === "undislike") {
							$place.dislikes = false
							$place.dislikeCount--
						}

						return () => {}
					}}
					class="w-full pt-4 px-0 pb-2"
					method="POST"
					action="?/like&privateTicket={$place.privateTicket}">
					<div class="flex justify-between pb-2">
						<button
							name="action"
							value={$place.likes ? "unlike" : "like"}
							aria-label={$place.likes ? "Unlike" : "Like"}
							class="btn p-0 px-1 text-emerald-5">
							<i
								class="fa{$place.likes
									? ' text-emerald-6 hover:text-emerald-3'
									: 'r text-neutral-5 hover:text-neutral-3'}
								fa-thumbs-up transition text-lg" />
						</button>
						<button
							name="action"
							value={$place.dislikes ? "undislike" : "dislike"}
							aria-label={$place.dislikes
								? "Undislike"
								: "Dislike"}
							class="btn p-0 px-1 text-red-5">
							<i
								class="fa{$place.dislikes
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
							style="width: {($place.likeCount /
								($place.dislikeCount + $place.likeCount || 1)) *
								100}%"
							aria-valuenow={$place.likeCount}
							aria-valuemin={0}
							aria-valuemax={$place.dislikeCount +
								$place.likeCount} />
						<div
							class="bg-red-5"
							role="progressbar"
							aria-label="Dislikes"
							style="width: {($place.dislikeCount /
								($place.dislikeCount + $place.likeCount || 1)) *
								100}%"
							aria-valuenow={$place.dislikeCount}
							aria-valuemin={0}
							aria-valuemax={$place.dislikeCount +
								$place.likeCount} />
					</div>
					<div class="flex justify-between">
						<span class="px-2">
							{$place.likeCount} like{$place.likeCount === 1
								? ""
								: "s"}
						</span>
						<span class="px-2">
							{$place.dislikeCount} dislike{$place.dislikeCount ==
							1
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
		{$place.description.text || ""}
	</Tab>

	<Tab {tabData}>
		{#if user?.permissionLevel === 5 || $place.ownerUser?.number === user?.number}
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
					<code class="pr-2">{loadCommand}</code>
					<button
						on:click={() => {
							navigator.clipboard.writeText(loadCommand)
							copiedSuccess = true
							setTimeout(() => (copiedSuccess = false), 4000)
						}}
						class="btn btn-sm btn-secondary py-1.5!"
						type="button">
						<fa fa-copy />
					</button>
					{#if copiedSuccess}
						<small
							id="copiedSuccess"
							transition:fade
							class="block text-yellow-5">
							Successfully copied command to clipboard
						</small>
					{/if}
				</Tab>
				<Tab tabData={tabData2}>
					<Autopilot
						{launch}
						serverTicket={$place.serverTicket}
						domain={data.domain} />
				</Tab>
			</div>
		{/if}
		<h4>Server List</h4>
		{#if online}
			<div class="card p-4 flex flex-row">
				<div class="w-1/6">
					<div class="pb-2">
						Currently Playing: {$place.players
							.length}/{$place.maxPlayers}
					</div>
					<button
						on:click={placeLauncher}
						id="join"
						class="btn btn-sm btn-primary">
						Join Server
					</button>
				</div>
				<div class="w-5/6 flex gap-3">
					{#each $place.players as user}
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
				class="self-center size-32 -translate-x-1/2">
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
					style={installed ? "" : "animation: none"} />
				<!--
					Here's my ass going back in time 200 commits to see what that CSS variable did, only to find that it never did anything.
					Hello, fellow time traveller!
				-->
			</div>
		{/key}
		{#if success}
			<span class="text-xl pt-6">
				"{$place.name}" is ready to play! Have fun!
			</span>
		{:else if installed}
			<span class="text-xl pt-6">
				Get ready to join "{$place.name}" by {$place.ownerUser
					?.username}!
			</span>
		{:else}
			<span class="text-xl pt-6">
				Install the Mercury client and start playing now!
			</span>
			<a
				class="btn btn-primary"
				href="https://setup.{data.domain}/MercuryPlayerLauncher.exe">
				Download 2013
			</a>
		{/if}
	</div>
</Modal>
