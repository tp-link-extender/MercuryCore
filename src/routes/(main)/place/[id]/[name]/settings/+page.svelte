<script lang="ts">
	import "./settings.styl"

	import ViewForm from "./View.svelte"
	import TicketForm from "./Ticket.svelte"
	import NetworkForm from "./Network.svelte"
	import PrivatelinkForm from "./Privatelink.svelte"
	import PrivacyForm from "./Privacy.svelte"

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
<div class="ctnr light-text">
	<h1 class="py-6">Configure {data.name}</h1>
	<TabNav bind:tabData />
	<Tab {tabData}>
		<h4>Game View</h4>
		<p class="grey-text">
			Change the title and description of your server.
		</p>
		<ViewForm {data} />
	</Tab>

	<Tab {tabData}>
		<h4>Network</h4>
		<p class="grey-text">
			Change the network configurations of your server.
		</p>
		<TicketForm {data} />
		{#key data.serverTicket}
			<NetworkForm {data} />
		{/key}
	</Tab>

	<Tab {tabData}>
		<h4>Privacy</h4>
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
