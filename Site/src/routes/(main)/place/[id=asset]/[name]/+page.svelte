<script lang="ts">
	import { deserialize, enhance } from "$app/forms"
	import Head from "$components/Head.svelte"
	import ReportButton from "$components/ReportButton.svelte"
	import Tab from "$components/Tab.svelte"
	import TabData from "$components/TabData"
	import TabNav from "$components/TabNav.svelte"
	import User from "$components/User.svelte"
	import fade from "$lib/fade"
	import { likeEnhance } from "$lib/like"
	import Autopilot from "./Autopilot.svelte"
	import customProtocol from "./customprotocol"
	import Thumbnails from "./Thumbnails.svelte"

	const { data } = $props()

	const { user } = data

	let place = $state(data.place)
	let online = $derived(place.serverPing > Date.now() / 1000 - 35)
	let currentPath = $derived(`/place/${place.id}/${data.slug}`)

	const statistics = $derived([
		// ["Activity", "0 visits"],
		["Created", new Date(place.created).toLocaleDateString()],
		["Updated", new Date(place.updated).toLocaleDateString()],
		["Server limit", place.maxPlayers],
		["Now playing", place.players.length]
	])

	// Place Launcher

	type State =
		| "not installed"
		| "waiting"
		| "starting"
		| "ready"
		| "success"
		| "fail"

	let popover = $state<HTMLDivElement>()
	let current = $state<State>("not installed")

	function privateFetchParams() {
		const body = new FormData()
		body.append("privateTicket", place.privateTicket)
		return { method: "post", body }
	}

	const launch = (joinscripturl: () => string) => {
		customProtocol(
			joinscripturl(),
			() => {
				// this isn't a guarantee that the game has succeeded in launching, but it's a decent guess I guess??
				current = "success"
				setTimeout(() => popover?.hidePopover(), 16000)
			},
			() => {
				current = "not installed"
			}
		)
	}

	// we don't want to start a server if the user is just opening studio to edit the place
	const beginJoining =
		(joinscripturl: () => string, startServer = false) =>
		async () => {
			current = "waiting"

			if (!startServer) {
				launch(joinscripturl)
				return
			}

			try {
				await fetch(`${currentPath}?/start`, privateFetchParams())
			} catch {
				current = "fail"
				return
			}

			const es = new EventSource(`${data.orbiterURL}/${place.id}`)
			es.onmessage = (e: MessageEvent<string>) => {
				const status = e.data
				console.log("EVENTSOURCE", status)
				if (status === "1") current = "starting"
				else if (status === "2") {
					current = "ready"
					launch(joinscripturl)
					es.close()
				} else if (status === "0") {
					current = "fail"
					es.close()
				}
			}
		}

	let loadCommand = $derived(
		`dofile "http://${data.domain}/game/host?ticket=${place.serverTicket}"`
	)

	async function placeLauncher() {
		current = "waiting"

		// Get the joinscript URL
		const response = await fetch(
			`${currentPath}?/join`,
			privateFetchParams()
		)
		const joinScriptData = deserialize(await response.text()) as {
			status: number
			data: { ticket: string }
		}
		if (joinScriptData.status !== 200) return

		// JoinScript is my favourite programming language (-i mean scripting language)
		const joinUri = data.scheme + joinScriptData.data.ticket
		beginJoining(() => joinUri, true)()
	}

	const tabs = ["Description", "Servers"]
	const isOwner = data.place.ownerUser?.username === user?.username
	if (
		(isOwner || user.permissionLevel === 5) &&
		(data.hosting === "Selfhosted" || data.hosting === "Both")
	)
		tabs.push("Selfhosted")

	let tabData = $state(TabData(data.url, tabs))
	let tabData2 = $state(
		TabData(data.url, ["Manual", "Autopilot"], undefined, "tab2")
	)
	let copiedSuccess = $state(false)
</script>

<Head name={data.siteName} title={place.name} />

<div class="ctnr max-w-240 light-text">
	<div class="grid grid-cols-1 md:(grid-cols-3 gap-4)">
		<div class="col-span-2 pb-4">
			<Thumbnails
				thumbnails={data.thumbnails}
				id={place.id}
				slug={data.slug} />
		</div>

		<div class="flex flex-col justify-between gap-3">
			<div class="card bg-darker p-4 pb-6 block">
				<div class="flex justify-between">
					<h1 class="text-2xl">{place.name}</h1>
					{#if place.ownerUser?.username === user?.username || user?.permissionLevel >= 4}
						<div>
							<a
								aria-label="Place settings"
								href="/place/{place.id}/{data.slug}/settings"
								class="btn btn-sm btn-secondary">
								<fa fa-sliders></fa>
							</a>
						</div>
					{/if}
				</div>
				<span class="flex py-2">
					<b class="pr-2">by</b>
					{#if place.ownerUser}
						<User
							user={place.ownerUser}
							size="1.5rem"
							bg="background"
							full
							thin />
					{/if}
				</span>
				<div>
					Gears: <fa fa-circle-xmark></fa>
				</div>
				<small
					class="text-white rounded-2 {online
						? 'bg-emerald-600'
						: 'bg-red-500'} p-2 py-1">
					{online ? "Online" : "Offline"}
				</small>
				<span class="float-end">
					<span class="dropdown">
						<fa fa-ellipsis-h class="dropdown-ellipsis"></fa>
						<div class="dropdown-content pt-2">
							<ul class="p-2 rounded-3">
								<ReportButton
									user={place.ownerUser?.username || ""}
									url="/place/{place.id}/{data.slug}" />
							</ul>
						</div>
					</span>
				</span>
			</div>
			<div id="buttons" class="flex flex-col">
				<button
					onclick={placeLauncher}
					class="btn btn-primary"
					popovertarget="ready">
					<img
						src="/place/join.svg"
						alt="Play button icon"
						class="h-8" />
				</button>

				<form
					use:enhance={likeEnhance(place, p => {
						place = p
					})}
					method="post"
					action="/api/like/place/{place.id}?privateTicket={place.privateTicket}"
					class="w-full pt-4 px-0 pb-2">
					<div class="flex justify-between pb-2">
						<button
							name="action"
							value={place.likes ? "unlike" : "like"}
							aria-label={place.likes ? "Unlike" : "Like"}
							class="btn p-0 px-1 text-emerald-500">
							<fa
								fa-thumbs-up
								class="transition text-lg {place.likes
									? 'text-emerald-600 hover:text-emerald-300'
									: 'text-neutral-600 hover:text-neutral-400'}">
							</fa>
						</button>
						<button
							name="action"
							value={place.dislikes ? "undislike" : "dislike"}
							aria-label={place.dislikes
								? "Undislike"
								: "Dislike"}
							class="btn p-0 px-1 text-red-500">
							<fa
								fa-thumbs-down
								class="transition text-lg {place.dislikes
									? 'text-red-500 hover:text-red-300'
									: 'text-neutral-600 hover:text-neutral-400'}">
							</fa>
						</button>
					</div>
					<div class="flex bg-a2 h-3px">
						<div
							class="bg-emerald-500 transition-width-300"
							role="progressbar"
							aria-label="Likes"
							style="width: {(place.likeCount /
								(place.dislikeCount + place.likeCount || 1)) *
								100}%"
							aria-valuenow={place.likeCount}
							aria-valuemin={0}
							aria-valuemax={place.dislikeCount +
								place.likeCount}>
						</div>
						<div
							class="bg-red-500 transition-width-300"
							role="progressbar"
							aria-label="Dislikes"
							style="width: {(place.dislikeCount /
								(place.dislikeCount + place.likeCount || 1)) *
								100}%"
							aria-valuenow={place.dislikeCount}
							aria-valuemin={0}
							aria-valuemax={place.dislikeCount +
								place.likeCount}>
						</div>
					</div>
					<div class="flex justify-between">
						<span class="px-2">
							{place.likeCount} like{place.likeCount === 1
								? ""
								: "s"}
						</span>
						<span class="px-2">
							{place.dislikeCount} dislike{place.dislikeCount ===
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

	<Tab bind:tabData>
		{place.description.text || ""}
	</Tab>

	<Tab bind:tabData>
		<h4>Server list</h4>
		<!-- {#if online} -->
		<div class="card p-4 flex flex-row">
			<div class="w-1/6">
				<div class="pb-2">
					{place.players.length}/{place.maxPlayers} currently playing
				</div>
				<button
					onclick={placeLauncher}
					id="join"
					class="btn btn-sm btn-primary">
					Join server
				</button>
				{#if isOwner && tabs.includes("Selfhosted")}
					<form
						use:enhance
						method="post"
						action="?/close"
						class="pt-2">
						<button
							onclick={placeLauncher}
							id="join"
							class="btn btn-sm btn-red-secondary">
							Close server
						</button>
					</form>
				{/if}
			</div>
			<div class="w-5/6 flex gap-3 h-fit">
				{#each place.players as user}
					<User {user} size="4.5rem" bg="darker" />
				{/each}
			</div>
		</div>
		<!-- {:else}
			This server is offline.
		{/if} -->
	</Tab>

	{#if tabs.includes("Selfhosted")}
		<Tab bind:tabData>
			<h3 class="pb-2">Hosting on {data.siteName}</h3>
			<p>
				To begin hosting your map for everybody to play, you need to
				make sure that you are forwarding the port you wish to run the
				server on. If you are unsure on how to host, there are many
				resources available online on how to port forward on your
				router.
			</p>
			<p>
				If you have port forwarded already, it's time to get your server
				running. Below are two methods of hosting &ndash; we recommend
				using Autopilot to get started easily.
			</p>
			<div class="flex items-start mb-4">
				<TabNav bind:tabData={tabData2} vertical class="pr-4 pl-0" />
				<Tab bind:tabData={tabData2}>
					<p>
						You can host your server by opening your map in
						<span class="px-1">
							<button
								class="btn btn-sm btn-tertiary"
								onclick={beginJoining(
									() => `${data.scheme}1+launchmode:ide`
								)}>
								<fa fa-arrow-up-right-from-square></fa>
								Studio
							</button>
						</span>
						and then paste the following command into the command bar:
					</p>
					<code class="pr-2">{loadCommand}</code>
					<button
						onclick={() => {
							navigator.clipboard.writeText(loadCommand)
							copiedSuccess = true
							setTimeout(() => (copiedSuccess = false), 4000)
						}}
						class="btn btn-sm btn-secondary py-1.5!"
						aria-label="Copy command to clipboard">
						<fa fa-copy></fa>
					</button>
					{#if copiedSuccess}
						<small
							id="copiedSuccess"
							transition:fade
							class="block text-yellow-500">
							Successfully copied command to clipboard
						</small>
					{/if}
				</Tab>
				<Tab bind:tabData={tabData2}>
					<Autopilot
						{beginJoining}
						scheme={data.scheme}
						serverTicket={place.serverTicket}
						domain={data.domain}
						siteName={data.siteName} />
				</Tab>
			</div>
		</Tab>
	{/if}
	<hr />
	<div class="flex justify-around">
		{#each statistics as [title, stat]}
			<div class="text-center">
				<div class="pb-4"><b>{title}</b></div>
				<p>{stat}</p>
			</div>
		{/each}
	</div>
	<hr />
</div>

<div bind:this={popover} id="ready" popover="auto">
	<div class="flex flex-col px-6 pt-6 text-center">
		<div class="self-center size-32 -translate-x-1/2">
			<img
				in:fade={{ duration: 500 }}
				src="/assets/icon"
				alt="{data.siteName} logo"
				class="absolute"
				width="128"
				height="128" />
		</div>
		{#if current === "success"}
			<span class="text-xl pt-6">
				"{place.name}" is ready to play! Have fun!
			</span>
		{:else if current === "waiting"}
			<span class="text-xl pt-6">
				Get ready to join "{place.name}" by {place.ownerUser?.username}!
			</span>
		{:else if current === "starting"}
			<span class="text-xl pt-6">
				Starting server for "{place.name}"... This may take a minute.
			</span>
		{:else if current === "ready"}
			<span class="text-xl pt-6">
				The server for "{place.name}" is ready! Launching the game...
			</span>
		{:else if current === "fail"}
			<span class="text-xl pt-6">
				Failed to start the server for "{place.name}". Please try again
				later.
			</span>
		{:else}
			<span class="text-xl pt-6">
				Install the {data.siteName} client and start playing now!
			</span>
			<a
				class="btn btn-primary"
				href="https://setup.{data.domain}/{data.siteName}PlayerLauncher.exe">
				Download 2013
			</a>
		{/if}
	</div>
</div>
