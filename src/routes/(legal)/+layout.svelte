<script lang="ts">
	import Navbar from "$lib/components/Navbar.svelte"
	import Footer from "$lib/components/Footer.svelte"
</script>

<div id="all">
	<Navbar />
	
	<main>
		<slot />
	</main>
	
	<Footer />
</div>

<style lang="sass">

    main
	    padding-bottom: 5vh
        padding-top: 10vh
        flex: 1 0 auto

    #all 
        display: flex
        flex-direction: column
        height: 100vh
        background: linear-gradient(-20deg, var(--footer) 50%, var(--mainaccent) 250%)
</style>
