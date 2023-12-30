<script lang="ts">
	export let place: import("./$types").PageData["places"][0]

	const ratio = Math.floor(
		(place.likeCount / (place.likeCount + place.dislikeCount)) * 100
	)
</script>

<div class="d-collapse light-text bg-darker rounded-3">
	<input type="radio" name="accordion" />
	<div class="d-collapse-title p-2">
		{place.name}
	</div>
	<div class="d-collapse-content">
		<a
			class="card bg-darker text-center light-text no-underline m-0 w-full"
			href="/place/{place.id}/{place.name}">
			<div class="flex">
				<div class="w-1/2">
					<div
						class="shadow overflow-hidden bg-black relative rounded-bl-4">
						<img
							src="/place/{place.id}/{place.name}/icon"
							alt={place.name}
							class="w-full" />
					</div>
				</div>
				<div class="w-1/2 flex flex-col justify-between py-2">
					<span>
						{place.name}
					</span>
					<div class="flex justify-between px-3">
						<span>
							<fa fa-thumbs-up class="opacity-75" />
							{isNaN(ratio) ? "--" : ratio}%
						</span>
						<span>
							<fa fa-user class="opacity-75" />
							{place.playerCount}
						</span>
					</div>
				</div>
			</div>
		</a>
	</div>
</div>

<style lang="stylus">
	a
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

	input[type="radio"]
		cursor pointer
</style>
