<script lang="ts">
	export let data
</script>

<Head title={data.name} />

<div id="all" class="container">
	<div class="d-flex px-6">
		<div class="container light-text">
			<h1 class="light-text">{data.name}</h1>
			<p class="light-text">
				<b>by</b>
				<a
					href="/user/{data.owner?.number}"
					class="user light-text text-decoration-none">
					<span class="pfp bg-darker rounded-circle ms-1">
						<img
							src="/api/avatar/{data.owner?.username}"
							alt={data.owner?.username}
							class="rounded-circle rounded-t-0" />
					</span>
					{data.owner?.username}
				</a>
			</p>
			<br />
			<div class="flex">
				<a
					href="/groups/{data.name}/members"
					class="light-text text-center text-decoration-none ms-6">
					Members
					<h3 class="light-text">
						{data.memberCount}
					</h3>
				</a>
				<form class="self-center ms-auto" method="POST" use:enhance>
					<button
						name="action"
						value={data.in ? "leave" : "join"}
						class="btn {data.in
							? 'bg-red-500'
							: 'bg-emerald-600 hover:bg-emerald-800 text-white'}">
						{#if data.in}
							Leave
						{:else}
							Join
						{/if}
					</button>
				</form>
			</div>
		</div>
	</div>
	{#if data.places.length > 0}
		<div class="mt-6">
			<h2 class="h4 light-text">Creations</h2>
			<div class="grid grid-cols-12 gap-6 m-0 p-0">
				{#each data.places as place, num}
					<div
						class="col col-span-4 sm:col-span-3 md:col-span-2 text-center">
						<Place {place} {num} total={data.places.length} />
					</div>
				{/each}
			</div>
		</div>
	{/if}
	{#if data.feed.length > 0}
		<h2 class="h4 mt-12 light-text">Latest feed posts</h2>
		<div id="feed" class="light-text p-4">
			<div class="row">
				{#each data.feed.sort((a, b) => b.posted.getTime() - a.posted.getTime()) as status}
					<div class="p-2 md:col-span-6 sm:col-span-12">
						<div class="card h-100">
							<div class="card-body pb-0">
								<div id="user" class="d-flex mb-2">
									<span class="font-bold ms-4 light-text">
										{data.name}
									</span>
									<span
										class="ms-auto italic light-text text-end">
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

<style lang="stylus">
	#all
		max-width 60rem

	.pfp
	.pfp img
		width 1.5rem
		height 1.5rem
</style>
