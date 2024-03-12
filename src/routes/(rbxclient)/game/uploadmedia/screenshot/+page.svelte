<script lang="ts">
	function openPictures() {
		window.external.OpenPicFolder() // roblox
	}
	function noBother() {
		window.external.PostImage(false, 0) // roblox 2
		window.close()
	}
</script>

<div class="ctnr app py-6 light-text">
	<img
		width="100"
		height="100"
		alt="DB:Z"
		src="https://cdn.shopify.com/s/files/1/0258/6899/2592/products/DRAGONBALLZSHENLONGANDKIDSGOKU_cff940fb-ca93-42dd-af31-d37d34a10e28.jpg?v=1586915490" />
	<h1 class="font-weight-normal pt-2">Mercury Screenshot</h1>
	<p>Hey, you just took a screenshot in Mercury! You could:</p>
	<ul>
		<li>
			Open <button on:click={openPictures} class="btn btn-sm btn-primary">
				<far fa-folder-open />
				My Pictures
			</button>
			to check it out!
		</li>
		<li>Paste it to your favorite painting software</li>
	</ul>
	<hr class="divider-bottom" />
	<button class="btn btn-sm btn-danger">
		<fa fa-ban />
		Not interested
	</button>
	<p class="text-white">Hey Kakarot, I think they found us</p>
</div>
