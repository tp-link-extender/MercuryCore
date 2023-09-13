<script lang="ts">
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

<Head title={data.username} />

<div id="all" class="container">
	<div class="card bg-darker pt-6">
		<div class="d-flex px-6">
			<User user={data} size="7rem" colour="accent"  image/>
			<div class="w-100 ps-8">
				<div class="d-flex mb-2">
					<h1 class="fs-2 light-text d-inline">{data.username}</h1>
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
				<div class="d-flex">
					<a
						href="/user/{data.number}/friends"
						class="light-text text-center text-decoration-none">
						Friends
						<h2 class="fs-3 light-text">
							{data.friendCount}
						</h2>
					</a>
					<a
						href="/user/{data.number}/followers"
						class="light-text text-center text-decoration-none ms-6">
						Followers
						<h2 class="fs-3 light-text">
							{data.followerCount}
						</h2>
					</a>
					<a
						href="/user/{data.number}/following"
						class="light-text text-center text-decoration-none ms-6">
						Following
						<h2 class="fs-3 light-text">
							{data.followingCount}
						</h2>
					</a>

					{#if data.username != user?.username}
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
				<div class="float-end mb-4">
					<ReportButton
						user={data.username}
						url="/user/{data.number}" />
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-6">
			{#if data.bio[0]}
				<div class="mt-6">
					<h2 class="fs-4 light-text">Bio</h2>
					<p class="light-text ms-2">{data.bio[0].text}</p>
				</div>
			{/if}
			<div class="mt-6">
				<h2 class="fs-4 light-text">Avatar</h2>
				<div class="card bg-darker card-body">
					<img
						id="avatar"
						class="mx-auto"
						src="/api/avatar/{data.username}-body"
						alt={data.username} />
				</div>
			</div>
		</div>
		<div class="col-6">
			{#if data.places.length > 0}
				<div class="mt-6">
					<h2 class="fs-4 light-text">Creations</h2>
					{#each data.places as place, num}
						<div
							in:fade|global={{
								num,
								total: data.places.length,
							}}
							class="d-collapse d-collapse light-text bg-darker mb-2 rounded-3">
							<input type="radio" name="accordion" />
							<div class="d-collapse-title p-2">
								{place.name}
							</div>
							<div class="d-collapse-content">
								<a
									class="card bg-darker shadow-none placecard text-center light-text text-decoration-none fs-6 m-0 w-100"
									href="/place/{place.id}/{place.name}">
									<div class="row">
										<div class="col col-6">
											<div
												class="overflow-hidden bg-black shadow">
												<img
													src="/place/{place.id}/{place.name}/icon"
													alt={place.name}
													class="w-100 h-100" />
											</div>
										</div>
										<div class="col col-6 p-2 row">
											<p class="mb-1 fs-5">
												{place.name}
											</p>
											<div class="mt-auto mb-1">
												<div class="float-start">
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
														{place.gameSessions
															.length}
													</span>
												</div>
											</div>
										</div>
									</div>
								</a>
							</div>
						</div>
					{/each}
				</div>
			{/if}
		</div>
		<div class="col-6 mt-6">
			{#if data.groupsOwned.length > 0}
				<div class="mt-6">
					<h2 class="fs-4 light-text">Groups owned</h2>
					{#each data.groupsOwned as group, num}
						<a
							in:fade={{ num, total: data.groupsOwned.length }}
							class="card bg-darker light-text text-decoration-none fs-6 my-2"
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
		<div class="col-6 mt-6">
			{#if data.groups.length > 0}
				<div class="mt-6">
					<h2 class="fs-4 light-text">Groups in</h2>
					{#each data.groups as group, num}
						<a
							in:fade={{ num, total: data.groups.length }}
							class="card bg-darker light-text text-decoration-none fs-6 my-2"
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
			<h2 class="fs-4 mt-12 light-text">Latest feed posts</h2>
			<div id="feed" class="light-text p-4">
				<div class="row">
					{#each data.posts.sort((a, b) => b.posted.getTime() - a.posted.getTime()) as status, num}
						<div
							in:fade={{ num, total: data.posts.length, max: 9 }}
							class="p-2 col-md-6 col-sm-12">
							<div class="card bg-darker p-2 h-100">
								<div id="user" class="d-flex mb-2">
									<span class="pfp rounded-circle bg-a2">
										<img
											src="/api/avatar/{data.username}"
											alt={data.username}
											class="rounded-circle rounded-top-0" />
									</span>
									<span class="font-bold ms-4 light-text">
										{data.username}
									</span>
									<span
										class="ms-auto italic light-text text-end">
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

<style lang="stylus">
	#all
		max-width 60rem

	.placecard
		transition all 0.2s
		border none
		&:hover
			transition all 0.2s
			.shadow::after
				box-shadow inset 0 0 4rem 0 #fff2

		.shadow
			aspect-ratio 1
			position relative
			&::after
				transition all 0.3s
				content ""
				position absolute
				top 0
				left 0
				width 100%
				height 100%

	#user
		align-items center
		.pfp img
			width 2rem

	#avatar
		aspect-ratio 3/4

	input[type="radio"]
		cursor pointer
</style>
