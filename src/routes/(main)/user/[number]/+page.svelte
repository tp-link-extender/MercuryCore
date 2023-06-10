<script lang="ts">
	import { enhance } from "$app/forms"
	import Report from "$lib/components/Report.svelte"
	import fade from "$lib/fade"

	const permissions = [
		[], // index from 1
		["white", "fa-user", "User"],
		["aqua", "fa-check", "Verified"],
		["violet", "fa-hammer", "Catalog Manager"],
		["orange", "fa-shield-alt", "Moderator"],
		["crimson", "fa-scale-balanced", "Administrator"],
	]

	export let data
	const { user } = data
</script>

<svelte:head>
	<title>{data.username} - Mercury</title>
</svelte:head>

<div id="all" class="container">
	<div class="card bg-darker pt-4">
		<div class="flex px-4">
			<div id="image-background" class="me-4 rounded-full bg-a">
				<img
					src="/api/avatar/{data.username}"
					alt={data.username}
					class="rounded-full rounded-top-0" />
			</div>
			<div class="container">
				<div class="flex mb-2">
					<h1 class="h2 light-text inline">{data.username}</h1>
					<b
						class="ms-auto"
						style="color: {permissions[data.permissionLevel][0]}">
						<i
							class="fa {permissions[
								data.permissionLevel
							][1]} me-1" />
						{permissions[data.permissionLevel][2]}
					</b>
				</div>
				<div class="flex">
					<a
						href="/user/{data.number}/friends"
						class="light-text text-center no-underline">
						Friends
						<h2 class="h3 light-text">
							{data.friendCount}
						</h2>
					</a>
					<a
						href="/user/{data.number}/followers"
						class="light-text text-center no-underline ms-4">
						Followers
						<h2 class="h3 light-text">
							{data.followerCount}
						</h2>
					</a>
					<a
						href="/user/{data.number}/following"
						class="light-text text-center no-underline ms-4">
						Following
						<h2 class="h3 light-text">
							{data.followingCount}
						</h2>
					</a>

					{#if data.username != user?.username}
						<form
							in:fade
							class="self-center ms-auto me-2"
							method="POST"
							use:enhance>
							<button
								name="action"
								value={data.friends
									? "unfriend"
									: data.outgoingRequest
									? "cancel"
									: data.incomingRequest
									? "accept"
									: "request"}
								class="btn {data.friends || data.outgoingRequest
									? 'bg-red-500'
									: data.incomingRequest
									? 'bg-cyan-600 hover:bg-cyan-800 text-white'
									: 'bg-emerald-600 hover:bg-emerald-800 text-white'}">
								{#if data.friends}
									Unfriend
								{:else if data.incomingRequest}
									Accept request
								{:else if data.outgoingRequest}
									Cancel request
								{:else}
									Send friend request
								{/if}
							</button>
							{#if data.incomingRequest}
								<button
									name="action"
									value="decline"
									class="btn bg-red-500 ms-2">
									Decline request
								</button>
							{/if}
						</form>
						<form
							in:fade
							class="self-center"
							method="POST"
							use:enhance>
							<button
								name="action"
								value={data.following ? "unfollow" : "follow"}
								class="btn {data.following
									? 'bg-red-500'
									: 'bg-blue-600 hover:bg-blue-800 text-white'}">
								{#if data.following}
									Unfollow
								{:else}
									Follow
								{/if}
							</button>
						</form>
					{/if}
				</div>
				<div class="float-right mb-3">
					<Report user={data.username} url="/user/{data.number}" />
				</div>
			</div>
		</div>
	</div>
	<div class="grid grid-cols-12 gap-6">
		<div class="col-span-6">
			{#if data.bio[0]}
				<div class="mt-4">
					<h2 class="h4 light-text">Bio</h2>
					<p class="light-text ms-2">{data.bio[0].text}</p>
				</div>
			{/if}
			<div class="mt-4">
				<h2 class="h4 light-text">Avatar</h2>
				<div class="card bg-darker card-body">
					<img
						id="avatar"
						class="w-60 mx-auto"
						src="/api/avatar/{data.username}-body"
						alt={data.username} />
				</div>
			</div>
		</div>
		<div class="col-span-6">
			{#if data.places.length > 0}
				<div class="mt-4">
					<h2 class="h4 light-text">Creations</h2>
					<div class="accordion" id="accordion">
						{#each data.places as place, num}
							<div
								in:fade={{ num, total: data.places.length }}
								class="accordion-item rounded-2 my-2">
								<div
									class="accordion-header rounded-2"
									id="heading{num}">
									<button
										class="accordion-button collapsed p-2 light-text rounded-3"
										type="button"
										data-bs-toggle="collapse"
										data-bs-target="#collapse{num}"
										aria-expanded="false"
										aria-controls="collapse{num}">
										{place.name}
									</button>
								</div>
								<div
									id="collapse{num}"
									class="accordion-collapse collapse rounded-3"
									aria-labelledby="heading{num}"
									data-bs-parent="#accordion">
									<div class="accordion-body rounded-3 p-0">
										<a
											in:fade={{
												num,
												total: data.places.length,
											}}
											class="card bg-darker shadow-none placecard text-center light-text no-underline h6 m-0 w-100"
											href="/place/{place.id}/{place.name}">
											<div
												class="grid grid-cols-12 gap-6">
												<div class="col col-span-6">
													<div
														class="overflow-hidden bg-black shadow">
														<img
															src="/place/{place.id}/{place.name}/icon"
															alt={place.name}
															class="w-100 h-100" />
													</div>
												</div>
												<div
													class="col col-span-6 p-2 row">
													<p class="mb-1 h5">
														{place.name}
													</p>
													<div class="mt-auto mb-1">
														<div class="float-left">
															<span>
																<i
																	class="fa fa-thumbs-up opacity-75" />
																{place.ratio}%
															</span>
														</div>
														<div
															class="float-right">
															<span>
																<i
																	class="fa fa-user opacity-75" />
																{place
																	.gameSessions
																	.length}
															</span>
														</div>
													</div>
												</div>
											</div>
										</a>
									</div>
								</div>
							</div>
						{/each}
					</div>
				</div>
			{/if}
		</div>
		<div class="col-span-6 mt-4">
			{#if data.groupsOwned.length > 0}
				<div class="mt-4">
					<h2 class="h4 light-text">Groups owned</h2>
					{#each data.groupsOwned as group, num}
						<a
							in:fade={{ num, total: data.groupsOwned.length }}
							class="card bg-darker light-text no-underline h6 my-2"
							href="/groups/{group.name}">
							<div class="p-2">
								<span class="float-left">
									{group.name}
								</span>
								<span class="float-right">
									<i class="fa fa-user opacity-75" />
									{group.members}
								</span>
							</div>
						</a>
					{/each}
				</div>
			{/if}
		</div>
		<div class="col-span-6 mt-4">
			{#if data.groups.length > 0}
				<div class="mt-4">
					<h2 class="h4 light-text">Groups in</h2>
					{#each data.groups as group, num}
						<a
							in:fade={{ num, total: data.groups.length }}
							class="card bg-darker light-text no-underline h6 my-2"
							href="/groups/{group.name}">
							<div class="p-2">
								<span class="float-left">
									{group.name}
								</span>
								<span class="float-right">
									<i class="fa fa-user opacity-75" />
									{group.members}
								</span>
							</div>
						</a>
					{/each}
				</div>
			{/if}
		</div>
		{#if data.posts.length > 0}
			<h2 class="h4 mt-5 light-text">Latest feed posts</h2>
			<div id="feed" class="light-text p-3">
				<div class="grid grid-cols-12 gap-6">
					{#each data.posts.sort((a, b) => b.posted.getTime() - a.posted.getTime()) as status, num}
						<div
							in:fade={{ num, total: data.posts.length, max: 9 }}
							class="p-2 md:col-span-6 sm:col-span-12">
							<div class="card bg-darker p-2 h-100">
								<div id="user" class="flex mb-2">
									<span class="pfp rounded-full bg-a2">
										<img
											src="/api/avatar/{data.username}"
											alt={data.username}
											class="rounded-full rounded-top-0" />
									</span>
									<span class="font-bold ms-3 light-text">
										{data.username}
									</span>
									<span
										class="ms-auto fw-italic light-text text-end">
										{status.posted.toLocaleString()}
									</span>
								</div>
								<p class="text-start mb-0">
									{status.content}
								</p>
							</div>
						</div>
					{/each}
				</div>
			</div>
		{/if}
	</div>
</div>

<style lang="sass">
	#all
		max-width: 60rem

	#image-background
		height: 7rem
		img
			height: 7rem

	.placecard
		transition: all 0.2s
		border: none
		&:hover
			transition: all 0.2s
			.shadow::after
				box-shadow: inset 0 0 4rem 0 #fff2

		.shadow
			aspect-ratio: 1
			position: relative
			&::after
				transition: all 0.3s
				content: ""
				position: absolute
				top: 0
				left: 0
				width: 100%
				height: 100%

	.accordion
		border: none
		div, button
			border: none
			box-shadow: none

	.accordion-body .bg-black
		overflow: hidden
		border-radius: 0 0 0 0.25rem !important

	#user
		align-items: center
		.pfp img
			width: 2rem

	#avatar
		aspect-ratio: 3/4
</style>
