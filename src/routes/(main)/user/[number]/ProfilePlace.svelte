<script lang="ts">
	export let place: import("./$types").PageData["places"][0]

	const ratio = Math.floor(
		(place.likeCount / (place.likeCount + place.dislikeCount)) * 100
	)
</script>

<div class="d-collapse d-collapse light-text bg-darker pb-2 rounded-3">
	<input type="radio" name="accordion" />
	<div class="d-collapse-title p-2">
		{place.name}
	</div>
	<div class="d-collapse-content">
		<a
			class="card bg-darker shadow-none placecard text-center light-text text-decoration-none m-0 w-100"
			href="/place/{place.id}/{place.name}">
			<div class="row">
				<div class="col col-6">
					<div class="overflow-hidden bg-black shadow">
						<img
							src="/place/{place.id}/{place.name}/icon"
							alt={place.name}
							class="w-100 h-100" />
					</div>
				</div>
				<div class="col col-6 p-2 row">
					<p>
						{place.name}
					</p>
					<div class="mt-auto">
						<div class="float-start">
							<span>
								<fa fa-thumbs-up class="opacity-75" />
								{isNaN(ratio) ? "--" : ratio}%
							</span>
						</div>
						<div class="float-end">
							<span>
								<fa fa-user class="opacity-75" />
								{place.playerCount}
							</span>
						</div>
					</div>
				</div>
			</div>
		</a>
	</div>
</div>

<style lang="stylus">
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

	input[type="radio"]
		cursor pointer
</style>
