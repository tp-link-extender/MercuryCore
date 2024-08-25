<script lang="ts">
	import { encode } from "$lib/urlName"

	export let place: import("./$types").PageData["places"][0]

	const slug = encode(place.name)
	const ratio = Math.floor(
		(place.likeCount / (place.likeCount + place.dislikeCount)) * 100
	)
</script>

<a
	class="card bg-darker light-text text-center no-underline w-full rounded-0 rounded-b-2"
	href="/place/{place.id}/{slug}">
	<div class="flex">
		<div class="w-1/2">
			<div class="shadow overflow-hidden bg-black relative rounded-bl-2">
				<img
					src="/place/{place.id}/{slug}/icon"
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
					{Number.isNaN(ratio) ? "--" : ratio}%
				</span>
				<span>
					<fa fa-user class="opacity-75" />
					{place.playerCount}
				</span>
			</div>
		</div>
	</div>
</a>

<style>
	a {
		transition: all 0.2s;
		border: none;
		&:hover {
			transition: all 0.2s;
			& .shadow::after {
				box-shadow: inset 0 0 4rem 0 rgba(255, 255, 255, 0.133);
			}
		}
	}

	.shadow {
		aspect-ratio: 1;
		position: relative;
		&::after {
			transition: all 0.3s;
			content: "";
			position: absolute;
			top: 0;
			left: 0;
			width: 100%;
			height: 100%;
		}
	}
</style>
