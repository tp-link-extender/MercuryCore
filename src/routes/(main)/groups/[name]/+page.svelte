<script lang="ts">
	export let data
</script>

<Head title={data.name} />

<div class="ctnr">
	<div class="px-6">
		<h1>{data.name}</h1>
		<p class="flex">
			<b class="pr-2">by</b>
			<User user={data.owner} full thin bg="accent" size="1.5rem" />
		</p>
		<div class="flex pt-6 justify-between">
			<a
				href="/groups/{data.name}/members"
				class="light-text text-center no-underline pl-6">
				Members
				<h3 class="light-text">
					{data.memberCount}
				</h3>
			</a>
			<form
				use:enhance
				method="POST"
				action="?/{data.in ? 'leave' : 'join'}"
				class="self-center">
				<button class="btn {data.in ? 'btn-danger' : 'btn-success'}">
					{#if data.in}
						Leave
					{:else}
						Join
					{/if}
				</button>
			</form>
		</div>
	</div>
	<!-- {#if data.places.length > 0}
		<div class="pt-6">
			<h2 class="text-base">Creations</h2>
			<div class="row m-0 p-0">
				{#each data.places as place, num}
					<div class="col col-4 col-sm-3 col-md-2 text-center">
						<Place {place} {num} total={data.places.length} />
					</div>
				{/each}
			</div>
		</div>
	{/if}
	{#if data.feed.length > 0}
		<h2 class="text-base pt-12">Latest feed posts</h2>
		<div id="feed" class="light-text p-4">
			<div class="row">
				{#each data.feed.sort((a, b) => new Date(b.posted).getTime() - new Date(a.posted).getTime()) as status}
					<div class="p-2 col-md-6 col-sm-12">
						<div class="card h-full">
							<div class="card-body pb-0">
								<div id="user" class="flex mb-2">
									<span class="font-bold ml-4 light-text">
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
	{/if} -->
</div>

<style lang="stylus">
	.ctnr
		max-width 60rem
</style>
