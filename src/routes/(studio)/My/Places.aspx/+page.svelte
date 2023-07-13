<h1>Your places</h1>

<div id="all">
	{#each Array(10) as _}
		<a href="/place">
			<img
				src="/place/placeholderIcon{Math.ceil(Math.random() * 3)}.png"
				alt="place" />
			<div class="text">
				<p>yeah game</p>
				<div>
					<div class="float-start">
						<fa class="thumbs-up" />
						50%
					</div>
					<div class="float-end">
						<fa class="user" />
						12
					</div>
				</div>
			</div>
		</a>
	{/each}
</div>

<style lang="stylus">
	@import "../../vars"

	a
		text-align center
		text-decoration none
		border-radius 0.5rem
		overflow hidden
		margin none
		width 10rem
		display inline-block
		margin 0.5rem
		color light-text

	fa
		font-family faSolid
		color grey-text
		line-height 1
	.thumbs-up::before
		content "\f164"
	.user::before
		content "\f007"

	.text
		background-color darker
		padding 0.7rem
		margin-top -0.5rem
		padding-bottom 1.8rem
	p
		margin 0
		margin-bottom 0.5rem

	.float-end
		float right
	.float-start
		float left

	img
		width 10rem
		height 10rem

	h1
		text-align center

	#all
		width fit-content
		text-align center
</style>
