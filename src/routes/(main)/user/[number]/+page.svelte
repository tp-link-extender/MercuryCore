<script lang="ts">
	import Interactions from "./Interactions.svelte"

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
	<div id="infocard" class="card bg-darker">
		<div class="d-flex">
			<span class="display-lg pe-6">
				<User user={data} size="7rem" bg="accent" image />
			</span>
			<span class="display-sm pe-4">
				<User user={data} size="6rem" bg="accent" image />
			</span>
			<div class="w-100">
				<div class="d-flex mb-2 justify-content-between">
					<div class="d-flex align-items-center">
						<h1 class="fs-2 light-text d-inline pe-4 mb-0">
							{data.username}
						</h1>
						{#if data.follower}
							<span class="grey-text bg-a px-2 rounded">
								Follows you
							</span>
						{/if}
					</div>
					<div class="d-flex align-self-start">
						<b
							style="color: {permissions[
								data.permissionLevel
							][0]}">
							<i
								class="fa {permissions[
									data.permissionLevel
								][1]} pe-1" />
							{permissions[data.permissionLevel][2]}
						</b>
					</div>
				</div>
				<div id="interactions" class="d-flex justify-content-between">
					<div class="d-flex gap-6">
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
							class="light-text text-center text-decoration-none">
							Followers
							<h2 class="fs-3 light-text">
								{data.followerCount}
							</h2>
						</a>
						<a
							href="/user/{data.number}/following"
							class="light-text text-center text-decoration-none">
							Following
							<h2 class="fs-3 light-text">
								{data.followingCount}
							</h2>
						</a>
					</div>

					<span class="display-lg">
						<Interactions {data} />
					</span>
				</div>
				<div class="float-end display-lg">
					<ReportButton
						user={data.username}
						url="/user/{data.number}" />
				</div>
			</div>
		</div>
		<span
			class="display-sm d-flex justify-content-between align-items-end pt-2">
			<Interactions {data} />
			<ReportButton user={data.username} url="/user/{data.number}" />
		</span>
	</div>
	<div class="row">
		<div class="col-6">
			{#if data.bio}
				<div class="pt-6">
					<h2 class="fs-4 light-text">Bio</h2>
					<p class="light-text ps-2">{data.bio.text}</p>
				</div>
			{/if}
			<div class="pt-6">
				<h2 class="fs-4 light-text">Avatar</h2>
				<div class="card bg-darker card-body">
					<img
						id="avatar"
						class="mx-auto"
						src="/api/avatar/{data.username}-body"
						alt={data.username} />
					{#if user?.permissionLevel > 2}
						<button class="btn btn-sm btn-primary position-absolute end-5"><i class="fas fa-arrows-rotate"/> Re-render</button>
					{/if}
				</div>
			</div>
		</div>
		<div class="col-6">
			{#if data.places.length > 0}
				<div class="pt-6">
					<h2 class="fs-4 light-text">Creations</h2>
					{#each data.places as place, num}
						{@const ratio = Math.floor(
							(place.likeCount /
								(place.likeCount + place.dislikeCount)) *
								100
						)}
						<div
							in:fade|global={{
								num,
								total: data.places.length,
							}}
							class="d-collapse d-collapse light-text bg-darker pb-2 rounded-3">
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
														{isNaN(ratio)
															? "--"
															: ratio}%
													</span>
												</div>
												<div class="float-end">
													<span>
														<i
															class="fa fa-user opacity-75" />
														{place.playerCount}
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
		{#if data.groupsOwned.length > 0}
			<div class="col-6 pt-6">
				<div class="pt-6">
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
									{group.memberCount}
								</span>
							</div>
						</a>
					{/each}
				</div>
			</div>
		{/if}
		{#if data.groups.length > 0}
			<div class="col-6 pt-6">
				<div class="pt-6">
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
									{group.memberCount}
								</span>
							</div>
						</a>
					{/each}
				</div>
			</div>
		{/if}
		{#if data.posts.length > 0}
			<h2 class="fs-4 pt-6 light-text">Latest feed posts</h2>
			<div id="feed" class="light-text px-4">
				<div class="row">
					{#each data.posts.sort((a, b) => new Date(b.posted).getTime() - new Date(a.posted).getTime()) as status, num}
						<div
							in:fade={{ num, total: data.posts.length, max: 9 }}
							class="p-2 col-md-6 col-sm-12">
							<div class="card bg-darker p-3 h-100">
								<div
									id="user"
									class="d-flex pb-2 justify-content-between">
									<User
										user={data}
										size="2rem"
										full
										image
										bg="accent" />
									<span class="italic light-text flex-end">
										{new Date(
											status.posted
										).toLocaleString()}
									</span>
								</div>
								<p class="text-start mb-0">
									{status.content[0].text}
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

	+lg()
		#infocard
			padding 1.5rem
		.display-sm
			display none !important
	+-lg()
		#infocard
			padding 1rem
		.display-lg
			display none !important
		#interactions
			flex-direction column
			align-items left

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

	#avatar
		aspect-ratio 3/4

	input[type="radio"]
		cursor pointer
</style>
