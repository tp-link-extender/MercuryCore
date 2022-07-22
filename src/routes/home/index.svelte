<script lang="ts">
	const friends = [
		{
			name: "Multako",
			img: "https://tr.rbxcdn.com/372efbed7319824170124853399ed562/150/150/AvatarHeadshot/Png",
			status: "Online",
		},
		{
			name: "Lewin5",
			img: "https://tr.rbxcdn.com/2daa018f45c826c666f21aefed82161f/150/150/AvatarHeadshot/Png",
			status: "Developing",
		},
		{
			name: "Taskmanager",
			img: "https://tr.rbxcdn.com/10a748f7422e0ef1ed49bdde580cf0ec/150/150/AvatarHeadshot/Png",
		},
		{
			name: "Boxerpizza",
			img: "https://tr.rbxcdn.com/4822f6355b367396437b7eed14048a7f/150/150/AvatarHeadshot/Png",
			status: "Online",
		},
		{
			name: "Wagness",
			img: "https://tr.rbxcdn.com/63fbca28e1fc28ed99915db948255b81/150/150/AvatarHeadshot/Png",
			status: "Joined",
		},
		{
			name: "Multako",
			img: "https://tr.rbxcdn.com/372efbed7319824170124853399ed562/150/150/AvatarHeadshot/Png",
			status: "Online",
		},
		{
			name: "Lewin5",
			img: "https://tr.rbxcdn.com/2daa018f45c826c666f21aefed82161f/150/150/AvatarHeadshot/Png",
			status: "Developing",
		},
		{
			name: "Taskmanager",
			img: "https://tr.rbxcdn.com/10a748f7422e0ef1ed49bdde580cf0ec/150/150/AvatarHeadshot/Png",
		},
		{
			name: "Boxerpizza",
			img: "https://tr.rbxcdn.com/4822f6355b367396437b7eed14048a7f/150/150/AvatarHeadshot/Png",
			status: "Online",
		},
		{
			name: "Wagness",
			img: "https://tr.rbxcdn.com/63fbca28e1fc28ed99915db948255b81/150/150/AvatarHeadshot/Png",
			status: "Joined",
		},
	]

	export let places: any

	// explicitly any to prevent warnings
	const statusColours: any = {
		Online: "bg-info",
		Joined: "bg-success",
		Developing: "bg-warning",
	}
</script>

<svelte:head>
	<title>Home - Mercury</title>
</svelte:head>

<div class="container">
	<div class="top d-flex px-2">
		<div id="pfp">
			<img src="https://tr.rbxcdn.com/10a748f7422e0ef1ed49bdde580cf0ec/150/150/AvatarHeadshot/Png" alt="You" />
		</div>
		<h1 class="text-center light-text">Hi, Mercury!</h1>
	</div>
	<div class="mt-5">
		<h4 class="light-text">Friends</h4>
		<div id="friends" class="d-flex">
			{#each friends as friend}
				<a class="friend px-2 mb-2 text-center light-text" href="/{friend.name}">
					<div class="position-relative mb-2">
						<div class="image-background">
							<img src={friend.img} alt={friend.name} />
						</div>
						{#if friend.status}
							<span class={`position-absolute bottom-0 end-0 badge rounded-circle ${statusColours[friend.status]}`}>
								<span class="visually-hidden">{friend.status}</span>
							</span>
						{/if}
					</div>
					{friend.name}
				</a>
			{/each}
		</div>
	</div>
	<div class="mt-5">
		<h4 class="light-text">Recently joined</h4>
		<div class="row p-0">
			{#each places as place}
				<a class="place col col-4 col-sm-3 col-md-2 text-center light-text px-2" href="/{place.ownerUsername}/{place.name}">
					<img src={place.image} class="mb-2" alt={place.name} />
					{place.name}
				</a>
			{/each}
		</div>
	</div>
	<br /><br />
</div>

<style lang="sass">
	.container
		max-width: 60rem
		font-size: 0.9rem

	.top
		width: fit-content
		#pfp
			background: var(--accent2)
			border-radius: 100%
		img
			height: 6rem
			border-radius: 100%
		h1
			margin: auto 2rem

	.row
		margin: 0

	#friends
		overflow-x: auto
		.friend 
			text-decoration: none
			.badge
				padding: 0.75rem
			.image-background
				background: var(--accent2)
				width: 7rem
				height: 7rem
				border-radius: 50%
				margin: auto
				img
					height: 100%
					border-radius: 50%
	.place
		border-radius: 0.5rem
		margin-bottom: 1rem
		text-decoration: none
		img
			width: 100%

	.place img
		border-radius: 0.5rem
</style>
