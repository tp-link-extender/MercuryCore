<script lang="ts">
	import { enhance } from "$app/forms"
	import Report from "$lib/components/Report.svelte"
	import { getUser } from "@lucia-auth/sveltekit/client"
	import fade from "$lib/fade"

	const user = getUser()

	const permissions: any = [
		[], // index from 1
		["white", "user", "User"],
		["aqua", "check", "Verified"],
		["violet", "hammer", "Catalog Manager"],
		["orange", "shield-alt", "Moderator"],
		["crimson", "scale-balanced", "Administrator"],
	]

	export let data
</script>

<svelte:head>
	<title>{data.username} - Mercury</title>
</svelte:head>

<div id="all" class="container">
	<div class="card pt-4">
		<div class="d-flex px-4">
			<div id="image-background" class="me-4 rounded-circle">
				<img
					src={data.image}
					alt={data.username}
					class="rounded-circle rounded-top-0" />
			</div>
			<div class="container">
				<div class="d-flex mb-2">
					<h1 class="h2 light-text d-inline">{data.username}</h1>
					<b
						class="ms-auto"
						style="color: {permissions[data.permissionLevel][0]}">
						<i
							class="fa fa-{permissions[
								data.permissionLevel
							][1]} me-1" />
						{permissions[data.permissionLevel][2]}
					</b>
				</div>
				<div class="d-flex">
					<a
						href="/user/{data.number}/friends"
						class="light-text text-center text-decoration-none">
						Friends
						<h3 class="light-text">
							{data.friendCount}
						</h3>
					</a>
					<a
						href="/user/{data.number}/followers"
						class="light-text text-center text-decoration-none ms-4">
						Followers
						<h3 class="light-text">
							{data.followerCount}
						</h3>
					</a>
					<a
						href="/user/{data.number}/following"
						class="light-text text-center text-decoration-none ms-4">
						Following
						<h3 class="light-text">
							{data.followingCount}
						</h3>
					</a>

					{#if data.username != $user?.username}
						<form
							in:fade
							class="align-self-center ms-auto me-2"
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
									? 'btn-danger'
									: data.incomingRequest
									? 'btn-info'
									: 'btn-success'}">
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
									class="btn btn-danger ms-2">
									Decline request
								</button>
							{/if}
						</form>
						<form
							in:fade
							class="align-self-center"
							method="POST"
							use:enhance>
							<button
								name="action"
								value={data.following ? "unfollow" : "follow"}
								class="btn {data.following
									? 'btn-danger'
									: 'btn-primary'}">
								{#if data.following}
									Unfollow
								{:else}
									Follow
								{/if}
							</button>
						</form>
					{/if}
				</div>
				<div class="float-end mb-3">
					<Report user={data.username} url="/user/{data.number}" />
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-6">
			{#if data.bio}
				<div class="mt-4 light-text">
					<h2 class="h4 light-text">Bio</h2>
					<p class="light-text ms-2">{data.bio}</p>
				</div>
			{/if}
		</div>
		<div class="col-6">
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
										class="accordion-button p-2 light-text rounded-3"
										type="button"
										data-bs-toggle="collapse"
										data-bs-target="#collapse{num}"
										aria-expanded="true"
										aria-controls="collapse{num}">
										{place.name}
									</button>
								</div>
								<div
									id="collapse{num}"
									class="accordion-collapse collapse rounded-3"
									aria-labelledby="heading{num}"
									data-bs-parent="#accordion">
									<div class="accordion-body rounded-3">
										<a
											in:fade={{
												num,
												total: data.places.length,
											}}
											class="card shadow-none placecard text-center light-text text-decoration-none h6 m-0 w-100"
											href="/place/{place.id}/{place.name}">
											<div class="row">
												<div class="col col-6">
													<div
														class="overflow-hidden bg-black shadow rounded-0">
														<img
															src={place.image}
															alt={place.name}
															class="w-100 h-100 rounded-0" />
													</div>
												</div>
												<div class="col col-6 p-2 row">
													<p class="mb-1 h5">
														{place.name}
													</p>
													<div class="mt-auto mb-1">
														<div
															class="float-start">
															<span>
																<i
																	class="fa fa-thumbs-up opacity-75" />
																{place.ratio}%
															</span>
														</div>
														<div class="float-end">
															<span>
																<i
																	class="fa fa-user opacity-75" />
																{place
																	.GameSessions
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
		<div class="col-6 mt-4">
			{#if data.groupsOwned.length > 0}
				<div class="mt-4">
					<h2 class="h4 light-text">Groups owned</h2>
					{#each data.groupsOwned as group, num}
						<a
							in:fade={{ num, total: data.groupsOwned.length }}
							class="card light-text text-decoration-none h6 my-2"
							href="/groups/{group.name}">
							<div class="p-2">
								<span class="float-start">
									{group.name}
								</span>
								<span class="float-end">
									<i class="fa fa-user opacity-75" />
									{group.members}
								</span>
							</div>
						</a>
					{/each}
				</div>
			{/if}
		</div>
		<div class="col-6 mt-4">
			{#if data.groups.length > 0}
				<div class="mt-4">
					<h2 class="h4 light-text">Groups in</h2>
					{#each data.groups as group, num}
						<a
							in:fade={{ num, total: data.groups.length }}
							class="card light-text text-decoration-none h6 my-2"
							href="/groups/{group.name}">
							<div class="p-2">
								<span class="float-start">
									{group.name}
								</span>
								<span class="float-end">
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
				<div class="row">
					{#each data.posts.sort((a, b) => b.posted - a.posted) as status, num}
						<div
							in:fade={{ num, total: data.posts.length, max: 9 }}
							class="p-2 col-md-6 col-sm-12">
							<div class="card h-100">
								<div class="card-body pb-0">
									<div id="user" class="d-flex mb-2">
										<span class="pfp rounded-circle">
											<img
												src={data.image}
												alt={data.username}
												class="rounded-circle img-fluid rounded-top-0" />
										</span>
										<span class="fw-bold ms-3 light-text">
											{data.username}
										</span>
										<span
											class="ms-auto fw-italic light-text text-end">
											{status.posted.toLocaleString()}
										</span>
									</div>
									<p class="text-start">
										{status.content}
									</p>
								</div>
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
		width: 7rem
		height: 7rem
		background: var(--accent)
		img
			height: 7rem

	.card
		background: var(--darker)

	.placecard
		transition: all 0.2s
		border: none
		&:hover
			transition: all 0.2s
			text-shadow: 0 0 5px var(--light-text)
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
			background: var(--darker)

	#feed
		.card
			background: var(--accent)
		#user
			align-items: center
			.pfp
				background: var(--accent2)
				img
					width: 2rem
</style>
