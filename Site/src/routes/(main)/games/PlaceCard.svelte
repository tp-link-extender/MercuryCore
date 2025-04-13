<script lang="ts">
	// Link to a place used on Games page.

	import fade from "$lib/fade"
	import { encode } from "$lib/urlName"

	interface Props {
		place: {
		id: number
		name: string
		likeCount: number
		dislikeCount: number
		serverPing: number
		playerCount: number
	};
		num: number;
		total: number;
	}

	let { place, num, total }: Props = $props();

	const slug = encode(place.name)
	const ratio = place.likeCount / (place.likeCount + place.dislikeCount)
	const percentage = Math.floor(ratio * 100)

	let online = $derived(place.serverPing > Date.now() / 1000 - 35)
</script>

<a
	in:fade|global={{ num, total }}
	class="card text-center no-underline rounded-4 w-90 md:w-82 lg:w-78 light-text bg-darker"
	href="/place/{place.id}/{slug}">
	<div class="flex" class:opacity-50={!online}>
		<div class="w-1/2">
			<div class="shadow overflow-hidden bg-black relative rounded-l-4">
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
					<fa fa-thumbs-up class="opacity-75"></fa>
					{Number.isNaN(percentage) ? "--" : percentage}%
				</span>
				<span>
					<fa fa-user class="opacity-75"></fa>
					{place.playerCount}
				</span>
			</div>
		</div>
	</div>
</a>

<style>
	a {
		line-height: 1.2;
		transition: all 0.2s;
		&:hover {
			transition: all 0.2s;
			& .shadow::after {
				box-shadow: inset 0 0 4rem 0 rgba(255, 255, 255, 0.133);
			}
		}
	}

	.shadow::after {
		transition: all 0.3s;
		content: "";
		position: absolute;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
	}
</style>
