<!-- basically just <noscript> except not when there's no script -->
<!-- uhh yeah -->

{#await new Promise(r => r())}
	<slot />
{/await}
