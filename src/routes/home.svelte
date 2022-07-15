<script lang="ts">
	let friends = [
		{
			name: "Multako",
			img: "https://tr.rbxcdn.com/372efbed7319824170124853399ed562/150/150/AvatarHeadshot/Png",
		},
		{
			name: "Lewin5",
			img: "https://tr.rbxcdn.com/2daa018f45c826c666f21aefed82161f/150/150/AvatarHeadshot/Png",
		},
		{
			name: "Taskmanager",
			img: "https://tr.rbxcdn.com/10a748f7422e0ef1ed49bdde580cf0ec/150/150/AvatarHeadshot/Png",
		},
		{
			name: "Boxerpizza",
			img: "https://tr.rbxcdn.com/4822f6355b367396437b7eed14048a7f/150/150/AvatarHeadshot/Png",
		},
		{
			name: "Wagness",
			img: "https://tr.rbxcdn.com/63fbca28e1fc28ed99915db948255b81/150/150/AvatarHeadshot/Png",
		},
	]

	let games = [
		{
			name: "Counter-Strike: Global Offensive",
			img: "https://tr.rbxcdn.com/32f4b1e24aa4b914ad5f21539338a60b/150/150/Image/Jpeg",
			by: "Goodimo",
		},
		{
			name: "CART RIDE INTO XLXI!",
			img: "https://tr.rbxcdn.com/5e4943326d89e35ee7f3659acb79b95e/150/150/Image/Jpeg",
			by: "Wagness",
		},
		{
			name: "[MEGA] The Underground War",
			img: "https://tr.rbxcdn.com/64d1f6db8ef51761eac1580114833c60/512/512/Image/Jpeg",
			by: "Heliodex",
		},
		{
			name: "Pinwind Bulders Coputer Coar",
			img: "https://tr.rbxcdn.com/ae0736ae8dfe0e3a1cc80aead2f49836/150/150/Image/Jpeg",
			by: "Heliodex",
		},
		{
			name: "Counter-Strike: Global Offensive",
			img: "https://tr.rbxcdn.com/32f4b1e24aa4b914ad5f21539338a60b/150/150/Image/Jpeg",
			by: "Goodimo",
		},
		{
			name: "CART RIDE INTO XLXI!",
			img: "https://tr.rbxcdn.com/5e4943326d89e35ee7f3659acb79b95e/150/150/Image/Jpeg",
			by: "Wagness",
		},
		{
			name: "[MEGA] The Underground War",
			img: "https://tr.rbxcdn.com/64d1f6db8ef51761eac1580114833c60/512/512/Image/Jpeg",
			by: "Heliodex",
		},
		{
			name: "Pinwind Bulders Coputer Coar",
			img: "https://tr.rbxcdn.com/ae0736ae8dfe0e3a1cc80aead2f49836/150/150/Image/Jpeg",
			by: "Heliodex",
		},
		{
			name: "Counter-Strike: Global Offensive",
			img: "https://tr.rbxcdn.com/32f4b1e24aa4b914ad5f21539338a60b/150/150/Image/Jpeg",
			by: "Goodimo",
		},
		{
			name: "CART RIDE INTO XLXI!",
			img: "https://tr.rbxcdn.com/5e4943326d89e35ee7f3659acb79b95e/150/150/Image/Jpeg",
			by: "Wagness",
		},
		{
			name: "[MEGA] The Underground War",
			img: "https://tr.rbxcdn.com/64d1f6db8ef51761eac1580114833c60/512/512/Image/Jpeg",
			by: "Heliodex",
		},
		{
			name: "Pinwind Bulders Coputer Coar",
			img: "https://tr.rbxcdn.com/ae0736ae8dfe0e3a1cc80aead2f49836/150/150/Image/Jpeg",
			by: "Heliodex",
		},
	]
</script>

<svelte:head>
	<title>Home - Mercury</title>
</svelte:head>

<div class="top container">
	<div class="d-flex">
		<div id="pfp">
			<img src="https://tr.rbxcdn.com/10a748f7422e0ef1ed49bdde580cf0ec/150/150/AvatarHeadshot/Png" alt="exelexeye" />
		</div>
		<h1 class="text-center">Hi, Mercury!</h1>
	</div>
</div>

<main class="container">
	<div class="row mt-3">
		<h4 class="text-center">Friends</h4>
		<div class="section">
			<div class="row">
				{#each friends as friend}
					<div class="friend col col-6 col-sm-4 col-md-3 col-lg-2">
						<a href="/user?name={friend.name}">
							<img src={friend.img} alt={friend.name} />
							<p class="text-center text-dark mt-1 mb-0">{friend.name}</p>
						</a>
					</div>
				{/each}
			</div>
		</div>
	</div>
	<div class="row mt-3">
		<h4 class="text-center">Recent games</h4>
		<div class="section">
			<div class="row">
				{#each games as game}
					<div class="game col col-6 col-sm-4 col-md-3 col-lg-2">
						<a href="/game?name={game.name}&by={game.by}">
							<img src={game.img} alt={game.name} />
							<p class="text-center text-dark mt-1 mb-0">{game.name}</p>
						</a>
					</div>
				{/each}
			</div>
		</div>
	</div>
	<br /><br />
</main>

<style lang="sass">
	main
		max-width: 60rem

	.section
		padding: 0.3rem
		.row
			background: white
			border-radius: 1rem
			padding: 1rem
	.top
		width: fit-content
		#pfp
			background: white
			border-radius: 100%
		img
			height: 6rem
			border-radius: 100%
		h1
			margin: auto 2rem

	.row
		margin: 0

	.game, .friend
		padding: 0 0.1rem
		border-radius: 0.5rem
		padding: 0.4rem
		img, p
			width: 100%
		a
			text-decoration: none

	.game img
		border-radius: 0.5rem
	.friend img
		border-radius: 100%
</style>
