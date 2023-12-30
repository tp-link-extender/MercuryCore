<script lang="ts">
	import Interactions from "./Interactions.svelte"
	import ProfilePlace from "./ProfilePlace.svelte"

	const permissions = [
		[], // index from 1
		["white", "fa-user", "User"],
		["aqua", "fa-check", "Verified"],
		["violet", "fa-hammer", "Catalog Manager"],
		["orange", "fa-shield-alt", "Moderator"],
		["crimson", "fa-scale-balanced", "Administrator"],
	]

	export let data
	export let form
	const { user } = data
</script>

<Head title={data.username} />

<div class="ctnr max-w-240">
	<div class="card bg-darker p-4 lg:p-6">
		<div class="flex">
			<span class="<lg:hidden pr-6">
				<User user={data} size="7rem" bg="accent" image />
			</span>
			<span class="lg:hidden pr-4">
				<User user={data} size="6rem" bg="accent" image />
			</span>
			<div class="w-full">
				<div class="flex mb-2 justify-between">
					<div class="flex items-center">
						<h1 class="inline pr-4 mb-0">
							{data.username}
						</h1>
						{#if data.follower}
							<span class="grey-text bg-a px-2 rounded">
								Follows you
							</span>
						{/if}
					</div>
					<div class="flex self-start">
						<b
							style="color: {permissions[
								data.permissionLevel
							][0]}">
							<i
								class="fa {permissions[
									data.permissionLevel
								][1]} pr-1" />
							{permissions[data.permissionLevel][2]}
						</b>
					</div>
				</div>
				<div id="interactions" class="flex justify-between">
					<div class="flex gap-6">
						<a
							href="/user/{data.number}/friends"
							class="light-text text-center no-underline">
							Friends
							<h2>
								{data.friendCount}
							</h2>
						</a>
						<a
							href="/user/{data.number}/followers"
							class="light-text text-center no-underline">
							Followers
							<h2>
								{data.followerCount}
							</h2>
						</a>
						<a
							href="/user/{data.number}/following"
							class="light-text text-center no-underline">
							Following
							<h2>
								{data.followingCount}
							</h2>
						</a>
					</div>

					<span class="<lg:hidden">
						<Interactions {data} />
					</span>
				</div>
				<div class="float-right <lg:hidden">
					<ReportButton
						user={data.username}
						url="/user/{data.number}" />
				</div>
			</div>
		</div>
		<span class="lg:hidden flex justify-between items-end pt-2">
			<Interactions {data} />
			<ReportButton user={data.username} url="/user/{data.number}" />
		</span>
	</div>
	<div class="grid grid-cols-2 gap-4">
		<div>
			{#if data.bio}
				<div class="pt-6">
					<h2 class="light-text">Bio</h2>
					<p class="light-text pl-2">{data.bio.text}</p>
				</div>
			{/if}
			<div class="pt-6">
				<h2 class="light-text">Avatar</h2>
				<div class="card bg-darker card-body">
					<img
						src={form?.avatar ||
							`/api/avatar/${data.username}-body`}
						alt={data.username} />
					{#if user?.permissionLevel > 2}
						<form
							use:enhance
							method="POST"
							action="?/rerender"
							in:fade
							class="absolute end-0 pr-4">
							<button class="btn btn-sm btn-primary">
								<fa fa-arrows-rotate />
								Re-render
							</button>
							<small class="text-danger block">
								{form?.msg || ""}
							</small>
						</form>{/if}
				</div>
			</div>
		</div>
		<div>
			{#if data.places.length > 0}
				<div class="pt-6">
					<h2 class="light-text">Creations</h2>
					<div class="flex flex-col gap-2">
						{#each data.places as place, num}
							<div
								in:fade|global={{
									num,
									total: data.places.length,
								}}>
								<ProfilePlace {place} />
							</div>
						{/each}
					</div>
				</div>
			{/if}
		</div>
		{#if data.groupsOwned.length > 0}
			<div class="col-6 pt-6">
				<div class="pt-6">
					<h2 class="light-text">Groups owned</h2>
					{#each data.groupsOwned as group, num}
						<div class="py-2">
							<a
								in:fade={{
									num,
									total: data.groupsOwned.length,
								}}
								class="card bg-darker light-text no-underline"
								href="/groups/{group.name}">
								<div class="p-2">
									<span class="float-start">
										{group.name}
									</span>
									<span class="float-right">
										<fa fa-user class="opacity-75" />
										{group.memberCount}
									</span>
								</div>
							</a>
						</div>
					{/each}
				</div>
			</div>
		{/if}
		{#if data.groups.length > 0}
			<div class="col-6 pt-6">
				<div class="pt-6">
					<h2 class="light-text">Groups in</h2>
					{#each data.groups as group, num}
						<div class="py-2">
							<a
								in:fade={{ num, total: data.groups.length }}
								class="card bg-darker light-text no-underline"
								href="/groups/{group.name}">
								<div class="p-2">
									<span class="float-start">
										{group.name}
									</span>
									<span class="float-right">
										<fa fa-user class="opacity-75" />
										{group.memberCount}
									</span>
								</div>
							</a>
						</div>
					{/each}
				</div>
			</div>
		{/if}
		{#if data.posts.length > 0}
			<h2 class="pt-6">Latest feed posts</h2>
			<div id="feed" class="light-text px-4">
				<div class="row">
					{#each data.posts.sort((a, b) => new Date(b.posted).getTime() - new Date(a.posted).getTime()) as status, num}
						<div
							in:fade={{ num, total: data.posts.length, max: 9 }}
							class="p-2 col-md-6 col-sm-12">
							<div class="card bg-darker p-3 h-full">
								<div
									id="user"
									class="flex pb-2 justify-between">
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
