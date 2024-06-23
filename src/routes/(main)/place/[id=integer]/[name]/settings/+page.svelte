<script lang="ts">
	import "./settings.css"
	import Head from "$lib/components/Head.svelte"
	import Tab from "$lib/components/Tab.svelte"
	import TabData from "$lib/components/TabData"
	import TabNav from "$lib/components/TabNav.svelte"
	import NetworkForm from "./Network.svelte"
	import PrivacyForm from "./Privacy.svelte"
	import PrivatelinkForm from "./Privatelink.svelte"
	import TicketForm from "./Ticket.svelte"
	import ViewForm from "./View.svelte"

	export let data

	let tabData = TabData(
		data.url,
		["View", "Network", "Privacy"],
		["far fa-eye", "fa fa-network-wired", "fa fa-eye-low-vision"]
	)
</script>

<Head title="{data.name} Settings" />

<!--
	Pretty chuffed with this way of organising forms, makes it way easier
	to have multiple forms on a page without them messing eachother up.
 -->
<div class="ctnr max-w-220 light-text">
	<div class="pb-4">
		<h1>Configure {data.name}</h1>
		<a href="/place/{data.id}/{data.slug}" class="no-underline">
			<fa fa-caret-left />
			Back to place
		</a>
	</div>
	<TabNav bind:tabData />
	<Tab {tabData}>
		<h2 class="text-xl">Game View</h2>
		<p class="grey-text">
			Change the title and description of your server.
		</p>
		<ViewForm {data} />
	</Tab>

	<Tab {tabData}>
		<h2 class="text-xl">Network</h2>
		<p class="grey-text">
			Change the network configurations of your server.
		</p>
		<TicketForm {data} />
		{#key data.serverTicket}
			<NetworkForm {data} />
		{/key}
	</Tab>

	<Tab {tabData}>
		<h2 class="text-xl">Privacy</h2>
		<p class="grey-text">
			Enable private server to make your game only accessible to those
			with the link.
		</p>
		<PrivatelinkForm {data} />
		{#key data.privateTicket}
			<PrivacyForm {data} />
		{/key}
	</Tab>
</div>
