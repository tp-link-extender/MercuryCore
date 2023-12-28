<script lang="ts">
	import superForm from "$lib/superForm"
	import Status from "./Status.svelte"

	export let data
	const { user } = data
	const formData = superForm(data.form)

	export const snapshot = formData

	$: sortedFeed = data.feed.sort(
		(a, b) => new Date(b.posted).getTime() - new Date(a.posted).getTime()
	)
</script>

<Head title="Home" />

<div class="ctnr">
	<div class="flex flex-wrap">
		<div class="w-full md:w-1/2 pr-2">
			<h1 class="w-full flex px-10 pb-6 my-0">
				<a
					href="/user/{user?.number}"
					class="no-underline light-text flex items-center">
					<User {user} size="6rem" bg="accent" image />
					<span class="ml-6">
						{data.stuff.greet}
					</span>
				</a>
			</h1>
			<div class="card p-4 bg-darker overflow-x-hidden <md:h-50vh">
				<p>
					Post your status - your friends and followers can view how
					you're doing!
				</p>
				<Form
					{formData}
					inline
					submit="<fa fa-paper-plane-top />"
					working="..."
					class="input-group w-full">
					<Input
						{formData}
						inline
						name="status"
						placeholder="Post status" />
				</Form>
				<div class="flex flex-col gap-3">
					{#each sortedFeed as status, num}
						<div
							in:fade|global={{
								num,
								total: data.feed.length,
							}}>
							<Status {status} />
						</div>
					{/each}
				</div>
			</div>
		</div>

		<div class="pt-12 md:pt-28 pl-2 flex gap-12 flex-col w-1/2">
			{#if data.friends.length > 0}
				<div>
					<h2 class="light-text">Friends</h2>
					<div class="home-row flex overflow-x-auto gap-4">
						{#each data.friends as friend, num}
							<!-- Larger delay between fades for more items -->
							<span
								in:fade|global={{
									num,
									total: data.friends.length,
								}}>
								<User
									user={friend}
									size="7rem"
									bg="accent"
									bottom />
							</span>
						{/each}
					</div>
				</div>
			{/if}
			<div>
				<h2 class="light-text">Resume playing</h2>
				<div class="home-row flex overflow-x-auto gap-4">
					{#each data.places || [] as place, num}
						<div class="min-w-32 w-32">
							<Place {place} {num} total={data.places.length} />
						</div>
					{/each}
				</div>
			</div>
			<div class="w-1/2 cmd:w-2/3 lg:w-1/2 xl:w-2/3">
				<h2 class="light-text">Random fact</h2>
				<div
					id="fact"
					class="card bg-darker card-body light-text text-base pb-6">
					{data.stuff.fact}
				</div>
			</div>
		</div>
	</div>
</div>
