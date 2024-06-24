<script lang="ts">
	let clicked = false
</script>

<footer class="relative flex justify-center <lg:pb-20 bg-darker">
	<div class="flex <sm:flex-col justify-between items-start w-200 p-4 pb-8">
		<div>
			<img src="/icon-footer.svg" alt="Mercury logo" class="size-8" />
			<a href="/" class="no-underline pl-2">Mercury</a>
			<span class="grey-text pl-1">
				2021-{new Date().getFullYear()}
			</span>
		</div>
		<div class="sm:text-right <sm:pt-4">
			<div class="flex <sm:flex-col sm:gap-3">
				<a class="light-text" href="/statistics">Statistics</a>
				&ndash;
				<button
					on:mousedown={() => (clicked = !clicked)}
					id="heart"
					class="border-0 p-0 pr-2 grey-text cursor-pointer text-base bg-transparent"
					class:clicked>
					<span class="grey-text">made with</span>
					<fa fa-heart />
				</button>
			</div>
		</div>
	</div>
</footer>

<noscript>
	<div id="nojs" class="fixed bottom-0 block w-screen">
		<p class="light-text text-center">
			Javascript is disabled. You may have a diminished experience while
			using Mercury.
		</p>
	</div>
</noscript>

<style>
	#heart {
		& fa {
			transition: 0.2s;
		}

		& span {
			transition: all 0.3s;
			display: inline-block;
			overflow: hidden;
			white-space: nowrap;
			width: 0;
			vertical-align: middle;
			margin-top: -0.2rem;
		}

		&:hover span {
			width: 5rem;
			margin-left: 0.2rem;
		}

		&:not(.clicked) fa:hover {
			color: var(--light-text) !important;
		}
	}

	@keyframes heart {
		0% {
			transform: scale(1);
		}
		15% {
			transform: scale(0.9);
			rotate: -10deg;
		}
		25% {
			transform: scale(1);
			rotate: 5deg;
		}
		40% {
			transform: scale(1.2);
			filter: drop-shadow(0 0 3px #f4b);
		}
		100% {
			transform: scale(1);
			rotate: 0;
		}
	}

	.clicked {
		& fa {
			animation: heart 2s;
		}
		& fa,
		& span {
			color: #f4b !important;
		}
	}

	footer {
		flex-shrink: 0;
		padding: 1vh;
		& a {
			text-decoration: none;
			&:hover {
				text-decoration: underline;
			}
		}
	}

	#nojs {
		background: rgba(0, 0, 0, 0.5);
		transform: translate(0px, 1rem);
	}
</style>
