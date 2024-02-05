<script lang="ts">
	import { Parallax, ParallaxLayer } from "svelte-parallax"
	import Pagepart from "./Pagepart.svelte"
</script>

<Parallax sections={2} config={{ stiffness: 1, damping: 1 }}>
	<ParallaxLayer offset={0} rate={0}>
		<Pagepart>
			<h1 class="sf font-bold">Endless possibilities</h1>
			<p class="text-xl">Mercury</p>
		</Pagepart>
	</ParallaxLayer>
	<ParallaxLayer offset={0} rate={-2}>
		<Pagepart right>
			<img
				class="w-full"
				src="/about_assets/screenshots.webp"
				alt="Devices playing Mercury" />
		</Pagepart>
	</ParallaxLayer>
	<ParallaxLayer offset={1} rate={2}>
		<Pagepart fullwidth>
			<h1 class="sf font-bold">New features</h1>
			<p class="text-xl">
				Mercury 2 has an even better website experience - easy to use
				and even more feature-packed than the previous website.
			</p>
		</Pagepart>
	</ParallaxLayer>
</Parallax>

<Parallax sections={2} config={{ stiffness: 1, damping: 1 }}>
	<ParallaxLayer offset={0} rate={0}>
		<Pagepart fullwidth>
			<h1 class="sf font-bold">Same nostalgia.</h1>
			<p class=" text-xl">
				We ensure the clients are as vanilla as possible so that you
				remember the client as it was back then.
			</p>
		</Pagepart>
	</ParallaxLayer>
	<ParallaxLayer offset={1} rate={0}>
		<Pagepart fullwidth>
			<h1 class="sf font-bold">
				Professional developers and community outreach.
			</h1>
			<p class=" text-xl">
				Mercury 2 developers deliver consistent updates so your
				experience is always great.
				<br />
				In addition, we aim to fix bugs and glitches as soon as they are
				reported.
				<br />
				Community wise, Mercury 2 aims to be completely transparent and non-biased
				with decisions.
				<br />
				While other private servers proceed to initiate petty wars with others,
				we take an impartial view.
			</p>
		</Pagepart>
	</ParallaxLayer>
</Parallax>

<Parallax sections={2} config={{ stiffness: 1, damping: 1 }}>
	<ParallaxLayer offset={0} rate={0}>
		<Pagepart fullwidth>
				<h1 class="sf font-bold">Why Mercury 2?</h1>
				<p class=" text-xl">
					Mercury 2 provides a simple yet elegant website, with an
					unique client and a forum, so you can communicate with your
					friends
					<br />
					- or make new ones!
				</p>
		</Pagepart>
	</ParallaxLayer>
	<ParallaxLayer offset={1} rate={0}>
		<Pagepart fullwidth>
			<div
				id="info"
				class="ctnr flex flex-col justify-center
				items-center relative">
				<h1 class="text-16 sf font-bold">Mercury 2</h1>
				<p class="lead light-text text-center">
					Endless possibilities. New features. Same nostalgia.
				</p>
				<b>
					<a
						type="button"
						href="/register"
						class="inline btn btn-sm btn-primary no-underline">
						Register <fa fa-chevron-right />
					</a>
				</b>
			</div>
		</Pagepart>
	</ParallaxLayer>
</Parallax>
