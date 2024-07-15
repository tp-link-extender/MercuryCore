<!-- the opposite of <noscript> -->

{#await new Promise(r => r(0)) then}
	<slot />
{/await}
