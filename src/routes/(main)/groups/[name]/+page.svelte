<script lang="ts">
	import { enhance } from "$app/forms"
	import Place from "$lib/components/Place.svelte"

	export let data
	const user = data.user
</script>

<svelte:head>
	<title>{data.name} - Mercury</title>
</svelte:head>

<div id="all" class="container">
	<div class="d-flex px-4">
		<div class="container light-text">
			<h1 class="light-text">{data.name}</h1>
			<p class="light-text">
				<b>By</b>
				<a href="/user/{data.owner.number}">{data.owner.username}</a>
			</p>
			<br />
			<div class="d-flex">
				<a
					href="/groups/{data.name}/members"
					class="light-text text-center text-decoration-none ms-4">
					Members
					<h3 class="light-text">
						{data.memberCount}
					</h3>
				</a>
				<form
					class="align-self-center ms-auto"
					method="POST"
					use:enhance>
					<button
						name="action"
						value={data.in ? "leave" : "join"}
						class="btn {data.in ? 'btn-danger' : 'btn-success'}">
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
		<div class="mt-4">
			<h2 class="h4 light-text">Creations</h2>
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
		<h2 class="h4 mt-5 light-text">Latest feed posts</h2>
		<div id="feed" class="light-text p-3">
			<div class="row">
				{#each data.feed.sort((a, b) => b.posted.getTime() - a.posted.getTime()) as status}
					<div class="p-2 col-md-6 col-sm-12">
						<div class="card h-100">
							<div class="card-body pb-0">
								<div id="user" class="d-flex mb-2">
									<span class="fw-bold ms-3 light-text">
										{data.name}
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

<style lang="sass">
	#all
		max-width: 60rem
</style>
